Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFX7fR009705 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:33:07 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDF551DF74C
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:33:06 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id Ow91sRYD6yDE4gLv for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:33:06 -0700 (PDT)
Message-ID: <4EA03F1F.4050109@oracle.com>
Date: Thu, 20 Oct 2011 23:32:47 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] 266: Functional test case for the btrfs raid
	operations
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1318919336-32206-4-git-send-email-Anand.Jain@oracle.com>
	<20111019094527.GD3083@infradead.org>
In-Reply-To: <20111019094527.GD3083@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


On 19/10/2011 17:45, Christoph Hellwig wrote:
>> +    if [ $dev_removed == 1 ]; then
>> +	umount $SCRATCH_MNT
>> +        _devmgt_add "${DEVHTL}"
>> +    fi
> 
> messy indendation.

  got it. thanks.

>> +	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
>> +	#btrfs filesystem show $SCRATCH_DEV 2>&1 | egrep devid |awk '{
>> +	#	if ( $6 == "0.00" ) { exit 1 }
>> +	#}' || _fail "test6_add... failed"
> 
> what is the point of the commented out code?
> 
> otherwise looks good to me.

  yes that has to be removed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
