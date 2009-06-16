Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GHWGcR171381
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 12:32:16 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC9D82FD521
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:32:40 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YUSWnmqTggJNOUqC for
	<linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 10:32:40 -0700 (PDT)
Message-ID: <4A37D737.70004@sandeen.net>
Date: Tue, 16 Jun 2009 12:32:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Preallocate using ALLOCSP
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>	
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>	
	<4A37B744.9030301@sandeen.net>	
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
In-Reply-To: <8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>
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
To: Smit Shah <getsmit@gmail.com>
Cc: linux-xfs@oss.sgi.com

Smit Shah wrote:
> On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:
>> On Jun 16, 2009, at 10:16 AM, Eric Sandeen wrote:


>>> Maybe I should ask what the end goal is here.  :)
>>>
> Just to see if preallocation using fallocate helps reducing the
> fragmentation and increases the throughput.  I guess it wll help
> reduce the fragmentation but the write performance is going to suffer.

Depends on the IO you do, I think.  I'd be curious to know exactly how
you're running preallocation & iometer so I could give it a shot, to see
why xfs seems to be doing worse than ext4.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
