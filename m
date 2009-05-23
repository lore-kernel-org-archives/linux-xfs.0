Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NG7CCE011925 for <xfs@oss.sgi.com>; Sat, 23 May 2009 11:07:12 -0500
Received: from smtprelay07.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3DA7414856FD
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 09:12:57 -0700 (PDT)
Received: from smtprelay07.ispgateway.de (smtprelay07.ispgateway.de
	[80.67.31.41]) by cuda.sgi.com with ESMTP id 6YDITMorfIQnxLZS
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 09:12:57 -0700 (PDT)
Message-ID: <20090523180721.94212hyfjppuupmo@webmail.df.eu>
Date: Sat, 23 May 2009 18:07:21 +0200
From: richard.ems@cape-horn-eng.com
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com> <4A181B40.9080608@sandeen.net>
In-Reply-To: <4A181B40.9080608@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


Quoting Eric Sandeen <sandeen@sandeen.net>:

> Richard Ems wrote:
>> Hi list,
>>
>> I'm getting the error "xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
>> Invalid argument" while trying to grow an XFS partition.
>>
>> This is on openSUSE 11.1 64 bit, with xfsprogs-2.10.2-3.1 from
>> http://download.opensuse.org/repositories/filesystems/openSUSE_11.1/x86_=
64/xfsprogs-2.10.2-3.1.x86_64.rpm
>
> The compat handlers should only matter if you're using 32 bit userspace
> with a 64 bit kernel...
>
> Are you certain that your xfsprogs userspace is 64-bit?

Yes.

c3m:~ # type -a xfs_growfs
xfs_growfs is /usr/sbin/xfs_growfs

c3m:~ # file /usr/sbin/xfs_growfs
/usr/sbin/xfs_growfs: ELF 64-bit LSB executable, x86-64, version 1  =

(SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs),  =

not stripped

>
>>
>> This error is the same or looks similar to the one reported some months
>> ago at http://oss.sgi.com/archives/xfs/2009-02/msg00028.html .
>>
>> There is apparently a fix for it, see
>> http://oss.sgi.com/archives/xfs/2008-12/msg01794.html :
>>
>> *********************************************************
>> commit 471d59103167c84f17b9bcfee22ed10b44ff206e
>> Author: sandeen@xxxxxxxxxxx <sandeen@xxxxxxxxxxx>
>> Date:   Tue Nov 25 21:20:10 2008 -0600
>>
>>     [XFS] Add compat handlers for data & rt growfs ioctls
>>
>>     The args for XFS_IOC_FSGROWFSDATA and XFS_IOC_FSGROWFSRTA
>>     have padding on the end on intel, so add arg copyin functions,
>>     and then just call the growfs ioctl helpers.
>>
>>     Signed-off-by: Eric Sandeen <sandeen@xxxxxxxxxxx>
>>     Reviewed-by: Christoph Hellwig <hch@xxxxxx>
>>     Signed-off-by: Lachlan McIlroy <lachlan@xxxxxxx>
>> *********************************************************
>>
>> I tried different 2.6.27 versions, one 2.6.29 and one 2.6.30-rc6
>> version, all gave the same error, check
>> https://bugzilla.novell.com/show_bug.cgi?id=3D506361 for the different
>> kernel versions and errors.
>
> I don't see in that bug where you tested .29 or .30, or what the results
> were...

Sorry, I wrote a 2nd comment into bugzilla but forgot to submit it 8( .
Now it's there, please check again (  =

https://bugzilla.novell.com/show_bug.cgi?id=3D506361#c1 ) .

>
>
>> Is this fix still not included in Linus / openSUSE trees?
>
> As for Linus' tree, AFAIK everything works; I can't speak to what SuSE ha=
s.

So the Vanilla kernel I tried should have this fix included, is it  =

then a new bug?

Thanks, Richard

--
Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
