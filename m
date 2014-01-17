Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 859377F6A
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 11:35:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5EADD8F8054
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 09:34:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Zee2GtUBCCAF30i0 for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 09:34:58 -0800 (PST)
Message-ID: <52D969E2.7030308@sandeen.net>
Date: Fri, 17 Jan 2014 11:35:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: allow logical-sector sized O_DIRECT for any fs sector
	size
References: <52D6CC91.6000408@redhat.com>
	<20140115223848.GZ3469@dastard>	<52D71115.1070309@sandeen.net>
	<20140116232132.GT3431@dastard>
In-Reply-To: <20140116232132.GT3431@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/16/14, 5:21 PM, Dave Chinner wrote:
> On Wed, Jan 15, 2014 at 04:52:05PM -0600, Eric Sandeen wrote:
>> On 1/15/14, 4:38 PM, Dave Chinner wrote:
>>> On Wed, Jan 15, 2014 at 11:59:45AM -0600, Eric Sandeen wrote:
>>>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>>>> index 33ad9a7..1f3431f 100644
>>>> --- a/fs/xfs/xfs_ioctl.c
>>>> +++ b/fs/xfs/xfs_ioctl.c
>>>> @@ -1587,7 +1587,12 @@ xfs_file_ioctl(
>>>>  			XFS_IS_REALTIME_INODE(ip) ?
>>>>  			mp->m_rtdev_targp : mp->m_ddev_targp;
>>>>  =

>>>> -		da.d_mem =3D da.d_miniosz =3D 1 << target->bt_sshift;
>>>> +		/*
>>>> +		 * Report device physical sector size as "optimal" minimum,
>>>> +		 * unless blocksize is smaller than that.
>>>> +		 */
>>>> +		da.d_miniosz =3D min(target->bt_pssize, target->bt_bsize);
>>>
>>> Just grab the filesysetm block size from the xfs_mount:
>>>
>>> 		da.d_miniosz =3D min(target->bt_pssize, mp->m_sb.sb_blocksize);
>>>
>>>> +		da.d_mem =3D da.d_miniosz;
>>>
>>> I'd suggest that this should be PAGE_SIZE - it's for memory buffer
>>> alignment, not IO alignment, so using the IO alignment just seems
>>> wrong to me...
>>
>> Ok.  Was just sticking close to what we had before.
>>
>> So:
>>  		da.d_miniosz =3D min(target->bt_pssize, mp->m_sb.sb_blocksize);
>> 		da.d_mem =3D PAGE_SIZE;
>>
>> ?  Then we can have a minimum IO size of 512, and a memory alignment of
>> 4k, isn't that a little odd?
>>
>> (IOWs we could do 512-aligned memory before, right?  What's the downside,
>> or the value in changing it now?)
> =

> We can do arbitrary byte aligned buffers if I understand
> get_user_pages() correctly - it just maps the page under the buffer
> into the kernel address space and then the bio is pointed at it.
> AFAICT, the reason for the "memory buffer needs 512 byte alignment"
> is simply that this is the minimum IO size supported.

Actually, it's fs/direct-io.c which enforces this (not sure why I couldn't
find that before), in do_blockdev_direct_IO(); the *enforced* minimum
memory alignment is the size of the bev's logical block size.

> However, for large IOs, 512 byte alignment is not really optimal. If
> we don't align the buffer to PAGE_SIZE, then we have partial head
> and tail pages, so for a 512k IO we need to map 129 pages into a bio
> instead of 128. When you have hardware that can only handle 128
> segments in a DMA transfer, that means the 512k IO needs to be sent
> in two IOs rather than one.

Ok, but I have a bit of a problem with changing what XFS_IOC_DIOINFO
reports.  (I had originally thought to change the minimum IO size, but
I have talked myself out of that, too).

The xfsctl(3) manpage says that XFS_IOC_DIOINFO:  "Get(s) information
required to perform direct I/O on the specified file descriptor."
and "the user=92s data buffer must conform to the same type of =

constraints as required for accessing a raw disk partition."

IOWs, the ioctl is documented as returning minimum, not optimal,
requirements, and it has always been implemented as such.  Changing
its meaning now seems wrong.  At least, I would not like to do so
as part of this functional change; to do so would probably be best
in a new ioctl which reports both minimum & optimal sizes.  And at
that point we should just do a vfs interface.  :)

Of course, applications don't have to use the minimum sizes reported
by the ioctl; they are free to be smarter and do larger sizes and
alignments.  But if the ioctl was designed and documented to report
required *minimums*, I think we should leave it as such.

I'm going to resend the change, split up a bit more to separate
cleanups from functional changes, and maybe we can discuss the ioctl
change as a potential additional patch.

Thanks,
-Eric

> There's quite a bit of hardware out there that have a limit of 128
> segments to each IO....
> =

> Cheers,
> =

> Dave.
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
