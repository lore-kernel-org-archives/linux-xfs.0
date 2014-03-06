Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE8DB7F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 11:58:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AA8718F8068
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 09:58:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id euCLMGef1k9Vtpx7 for
	<xfs@oss.sgi.com>; Thu, 06 Mar 2014 09:57:59 -0800 (PST)
Date: Thu, 6 Mar 2014 18:57:17 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2 1/8] xfstests: Create single function for testing
	xfs_io commands
In-Reply-To: <20140306174420.GA28297@infradead.org>
Message-ID: <alpine.LFD.2.00.1403061856070.2249@localhost.localdomain>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
	<1394034699-21187-2-git-send-email-lczerner@redhat.com>
	<20140306174420.GA28297@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Thu, 6 Mar 2014, Christoph Hellwig wrote:

> Date: Thu, 6 Mar 2014 09:44:20 -0800
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH v2 1/8] xfstests: Create single function for testing
>     xfs_io commands
> 
> On Wed, Mar 05, 2014 at 04:51:32PM +0100, Lukas Czerner wrote:
> > Currently there are several function testing various xfs_io commands.
> > This commit creates _require_xfs_io_command() to test any xfs_command.
> 
> Looks good.  Do you plan to keep the wrappers around
> _require_xfs_io_command in the long run or just for a transitional
> period?

I didn't really want to go back and change all the callers, but it
can be done eventually. I do not have any strong opinions either
way.

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
