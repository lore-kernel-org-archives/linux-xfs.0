Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4U8RUet124834 for <xfs@oss.sgi.com>; Sat, 30 May 2009 03:27:30 -0500
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A13EB1A4EFF0
	for <xfs@oss.sgi.com>; Sat, 30 May 2009 01:27:44 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.173]) by cuda.sgi.com with ESMTP id
	Vzpkb5K4GFeCt6jq for <xfs@oss.sgi.com>;
	Sat, 30 May 2009 01:27:44 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so2077944wff.32
	for <xfs@oss.sgi.com>; Sat, 30 May 2009 01:27:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090529201031.GA20031@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090528121947.GB30037@infradead.org>
	<921ca19c0905290619l46fa73abj380238058ce6efc6@mail.gmail.com>
	<20090529201031.GA20031@infradead.org>
Date: Sat, 30 May 2009 13:57:44 +0530
Message-ID: <921ca19c0905300127g2795e701uaab40be57cb5f143@mail.gmail.com>
Subject: Re: [PATCH 9/7] xfs: remove SYNC_BDFLUSH
From: Sujit Karataparambil <sjt.kar@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Is this the journalling part of the code?
Does SYNC_BDFLUSH  and SYNC_IOWAIT Determine the journalling?
Is it that the Journals are a part of SYNC_BDFLUSH  and SYNC_WAIT
resource locking?

How does the SYNC_TRYLOCK change the scenario? Is it some sort
of semaphore implementation?

Thanks,




On Sat, May 30, 2009 at 1:40 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, May 29, 2009 at 06:49:39PM +0530, Sujit Karataparambil wrote:
>> Hi,
>> Newbie question?
>> Kindly tell me where this code is called from do you have pagedeamon
>> on vfs or is it some thing else?
>
> currently all calls with SYNC_BDFLUSH are from xfssyncd.
>
>



-- 
-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
