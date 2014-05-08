Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F9C47F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 05:05:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CDC048F8039
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:05:42 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nc2HIEWWCLZCyDhJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 03:05:38 -0700 (PDT)
Date: Thu, 8 May 2014 18:05:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508100528.GD3407@localhost.localdomain>
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
	<20140508041123.GB3407@localhost.localdomain>
	<20140508110522.21930dfd@f163.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508110522.21930dfd@f163.suse.de>
Reply-To: bo.li.liu@oracle.com
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
To: David Disseldorp <ddiss@suse.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, May 08, 2014 at 11:05:22AM +0200, David Disseldorp wrote:
> Hi liubo,
> 
> On Thu, 8 May 2014 12:11:24 +0800, Liu Bo wrote:
> 
> > Something different here, I didn't get EIO on 3.15.0-rc4.
> 
> Strange, I'm able to consistently reproduce this on a
> vanilla v3.15-rc4-202-g30321c7 kernel.
> Does that mean the updated test passes successfully for you?

(yeah I've reproduce that error as well)

The interesting thing is that if you do a _scratch_remount before
'cat $SCRATCH_MNT/src', it goes well, I'm looking into why...

-liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
