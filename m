Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 535FB7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:24:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3C55AC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 14:24:41 -0700 (PDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id SRvGkZt2YKoopvlU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2015 14:24:34 -0700 (PDT)
Received: by lalv9 with SMTP id v9so106999701lal.0
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 14:24:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
Date: Tue, 25 Aug 2015 14:24:32 -0700
Message-ID: <CABppvi5GA_r6nN4Eg5JyuHQq2-6xbXhgQ-N-5BdiBwLT_8n-fg@mail.gmail.com>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
From: Shrinand Javadekar <shrinand@maginatics.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Does previously existing data on disk affect fragmentation?

On Tue, Aug 25, 2015 at 1:32 PM, Shrinand Javadekar
<shrinand@maginatics.com> wrote:
> Hi,
>
> I have 23 disks formatted with XFS on a single server. The workload is
> Openstack Swift. See this email from a few months ago about the
> details:
>
> http://oss.sgi.com/archives/xfs/2015-06/msg00108.html
>
> I am observing some strange behavior and would like to get some
> feedback about why this is happening.
>
> I formatted the disks with xfs (mkfs.xfs) and deployed Openstack Swift
> on it. Writing 100GB of data into Swift in batches of 20GB each gave
> us the following throughput:
>
>  20 GB: 93MB/s
>  40 GB: 65MB/s
>  60 GB: 52MB/s
>  80 GB: 50MB/s
> 100 GB: 48MB/s
>
> I then re-formatted the disks with mkfs.xfs -f and ran the experiment
> again. This time I got the following throughput:
>
>  20 GB: 118MB/s
>  40 GB: 95MB/s
>  60 GB: 74MB/s
>  80 GB: 68MB/s
> 100 GB: 63MB/s
>
> I've seen similar results twice.
>
> Any ideas why this might be happening?
>
> Thanks in advance.
> -Shri

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
