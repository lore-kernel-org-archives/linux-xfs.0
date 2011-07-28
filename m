Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6SHpx69004592 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 12:52:00 -0500
Received: from mo-p00-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6D1F10B3DA5
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 10:52:14 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id PfAMUz8iCVAkqU9B for
	<xfs@oss.sgi.com>; Thu, 28 Jul 2011 10:52:14 -0700 (PDT)
Message-ID: <4E31A19E.3040404@giantdisaster.de>
Date: Thu, 28 Jul 2011 19:51:26 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfstests: Add support for btrfs in 062
References: <cover.1311776403.git.sbehrens@giantdisaster.de>
	<d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de>
	<20110728084504.GA3407@infradead.org>
In-Reply-To: <20110728084504.GA3407@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 7/28/2011 10:45 AM, Christoph Hellwig wrote:
> On Thu, Jul 28, 2011 at 10:27:58AM +0200, Stefan Behrens wrote:
>> Added btrfs to the list of supported filesystems for this test.
>> Remove output of mkfs since this is specific to mkfs.xfs and now filtered
>> out.
> 
> Why can't it be generic?  Any reason this one doesn't work on e.g. ext2
> or reiserfs?

The only reason for not making the tests 015, 062, 083, 117, 120 and
192 "_supported_fs generic" was to keep the effect of the changes
minimal.
But I agree that they are generic ones and I have now changed it
accordingly in the revised patch series that I will send soon.
Thanks for your comments!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
