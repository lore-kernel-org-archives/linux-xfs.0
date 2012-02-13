Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHQmte027544 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:26:49 -0600
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.93]) by cuda.sgi.com with ESMTP id dCoBRxRspU3bqMDU
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 09:26:47 -0800 (PST)
Message-ID: <4F3947D6.5060402@cape-horn-eng.com>
Date: Mon, 13 Feb 2012 18:26:46 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
In-Reply-To: <20120213171556.GA13449@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/13/2012 06:15 PM, Christoph Hellwig wrote:
> On Mon, Feb 13, 2012 at 06:11:30PM +0100, Richard Ems wrote:
>> On 02/13/2012 06:08 PM, Christoph Hellwig wrote:
>>> On Mon, Feb 13, 2012 at 05:57:58PM +0100, Richard Ems wrote:
>>>> This is a backup system running dirvish, so most files in the dirs I am
>>>> removing are hard links. Almost all of the files do have ACLs set.
>>>
>>> How many ACLs do you usually have set?  If they aren't stored inline
>>> but need to go out of the inode unlinks will be extremly slow for
>>> kernels before v3.2.
>>>
>>
>> Almost all dirs and files there do have ACLs set.
>> Each of them do have about 10 user ACLs and 10 default ACls.
>> Is that too many?
>> Is this then the reason for being that slow?
> =

> That doesn't sound like a lot to me, but instead of guessing around,
> let's just check the actual facts.
> =

> Does "xfs_bmap -a" for the kind of files you are deleting show any
> extents? If it doesn't the output will look like:
> =

> # xfs_bmap -a internal
> internal: no extents
> =

> if it has any it will look like:
> =

> # xfs_bmap -a external
> external:
> 	0: [0..7]: 8557712..8557719
> =


YES. All files (and dirs) that I checked do show something as

0: [0..7]: 18531216..18531223

So, what improvements can I expect from a kernel > 3.2 ?
Can I read somewhere about the changes/patches introduced?
Is there another way to mount/create/mkfs the XFS to improve the unlink
time for this case?


Thanks again,
Richard


-- =

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
