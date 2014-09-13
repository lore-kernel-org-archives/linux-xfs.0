Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A61B67F37
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 20:44:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33140AC002
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 18:44:48 -0700 (PDT)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
	[66.111.4.28]) by cuda.sgi.com with ESMTP id Fs4aE02VlYSFYALH
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Sep 2014 18:44:43 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by gateway2.nyi.internal (Postfix) with ESMTP id E074C20A8A
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 21:44:42 -0400 (EDT)
Date: Fri, 12 Sep 2014 18:44:41 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: XFS fixes needed in stable kernels
Message-ID: <20140913014441.GA21972@kroah.com>
References: <20140820001623.GT20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140820001623.GT20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Fanael Linithien <fanael4@gmail.com>, stable@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 20, 2014 at 10:16:23AM +1000, Dave Chinner wrote:
> Hi Stable Kernel Gurus!
> 
> The following XFs fixes need to be pushed back to stable kernels.
> The commits weren't all tagged in the recent 3.17-rc1 merge, so
> you're getting an email from me instead. The commits required
> from 3.17-rc1 are:
> 
> 67dc288 xfs: ensure verifiers are attached to recovered buffers

You already marked this one, but it didn't apply to 3.10-stable

> 5fd364f xfs: quotacheck leaves dquot buffers without verifiers

Now queued up.

> ad3714b xfs: dquot recovery needs verifiers

Didn't apply at all to 3.16-stable :(

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
