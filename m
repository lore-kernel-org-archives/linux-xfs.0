Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CItZiZ024285 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 13:55:35 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id EjOlQxDgTTd5nb5U for <xfs@oss.sgi.com>;
	Tue, 12 Jun 2012 11:55:33 -0700 (PDT)
Message-ID: <4FD790A4.8010907@sandeen.net>
Date: Tue, 12 Jun 2012 13:55:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: block sizes > 4K ??  possible w/large page support?
References: <4FD5643F.5070801@tlinx.org> <4FD6AA2A.3020502@sandeen.net>
	<4FD77E45.8010402@tlinx.org>
In-Reply-To: <4FD77E45.8010402@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 6/12/12 12:37 PM, Linda A. Walsh wrote:
> 
> 
> Eric Sandeen wrote:
>> On 6/10/12 10:21 PM, Linda A. Walsh wrote:
>>> Is this something being thought about??
>>>
>>> More than one of my hard disks:
>>>
>>> /boot:                 130 files in     103112 4K blocks:    793.6 blks/file
>>> /tmp:                 1401 files in     746715 4K blocks:    533.4 blks/file
>>> /var/cache:           1438 files in      87858 4K blocks:     61.5 blks/file
>>> /backups:              713 files in 2523985177 4K blocks: 3539951.6 blks/file
>>> /var:                 9038 files in     746715 4K blocks:     83.1 blks/file
>>> /var/cache/squid:      570 files in      90031 4K blocks:    158.4 blks/file
>>> /Media:              51893 files in 1691400956 4K blocks:  32594.5 blks/file
>>> /:                   37312 files in     506778 4K blocks:     14.0 blks/file
>>> /usr/share:         320805 files in  195425485 4K blocks:    609.6 blks/file
>>> /backups/Media:      50544 files in 1642550112 4K blocks:  32497.9 blks/file
>>> /usr:               116650 files in    1389380 4K blocks:     12.4 blks/file
>>> /Share:            1617995 files in  305269701 4K blocks:    189.1 blks/file
>>> /home:             5822174 files in  195412389 4K blocks:     34.0 blks/file
>>>
>>> All but 2 could benefit from a 16K block size, and 3 of them could benefit
>>> from a 128K block size.  Wouldn't that benefit in  in freeing up some space
>>> both on disk and in memory?  Just a thought.
>>
>> Since on average each file in an evenly-distributed filesystem wastes half
>> a block, in theory each fs would waste 4x more space w/ 16k blocks than
>> 4k blocks, right?
> ---
>     Well the real candidates for a larger block size would be backups,
> and maybe Media... the rest wouldn't benefit.
> 
>     So, it sounds like I might just as well benefit by going to a 1K
> block size, if there's no cost in smaller block sizes?  Or would that be
> entirely dependent on the files/dir?

Well, there are some metadata overhead costs there, so it's a tradeoff.

Like we always say, use the defaults unless you can definitively show
that other options work better for your needs after testing.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
