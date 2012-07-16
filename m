Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GLuRvW019085 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 16:56:27 -0500
Received: from mail-gh0-f181.google.com (mail-gh0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	WWQqQpvkSixG6wzO (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Jul 2012 14:56:25 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so7099472ghb.26
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:56:25 -0700 (PDT)
Message-ID: <50048E2B.7060803@gmail.com>
Date: Mon, 16 Jul 2012 17:56:59 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs_repair failing.
References: <20120716235154.0d9b7c45@galadriel.home>
In-Reply-To: <20120716235154.0d9b7c45@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 07/16/2012 05:51 PM, Emmanuel Florac wrote:
>
> Hi list,
> I have a serious problem with a 60 TB XFS filesystem which looks
> seriously hosed. It was repaired once earlier last week, but crashed
> again after a repair friday and now xfs_repair fails with this message:
>
>   bad magic # 0x1 in btcnt block 61/27137
>   bad magic # 0xfffe68ff in btcnt block 61/201728942
>
> (xfs_repair 2.9.8)
>
> The filesystem can only be mounted read-only at this point.
>
> I suspect a RAID corruption (Adaptec 52445 with firmware 18252, Hitachi
> HUA 3TB drives, RAID 6). The RAID controller have been replaced, but it
> doesn't help. Any ideas?
>

Can you update the xfs tools to the current (3.1.8 I think)?  Also, 
which kernel is being used?



-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
