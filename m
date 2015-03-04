Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 105487F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 08:54:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 848F2AC005
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 06:54:56 -0800 (PST)
Received: from mail-we0-f172.google.com (mail-we0-f172.google.com
	[74.125.82.172]) by cuda.sgi.com with ESMTP id QNGuE6ye2VReqFyd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 Mar 2015 06:54:54 -0800 (PST)
Received: by wevk48 with SMTP id k48so3420322wev.7
	for <xfs@oss.sgi.com>; Wed, 04 Mar 2015 06:54:53 -0800 (PST)
Message-ID: <54F71CBA.2@gmail.com>
Date: Wed, 04 Mar 2015 16:54:50 +0200
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfs: add DAX file operations support
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
	<1425425427-16283-4-git-send-email-david@fromorbit.com>
	<54F6D9E4.9050803@gmail.com> <20150304130100.GU18360@dastard>
In-Reply-To: <20150304130100.GU18360@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On 03/04/2015 03:01 PM, Dave Chinner wrote:
> On Wed, Mar 04, 2015 at 12:09:40PM +0200, Boaz Harrosh wrote:
<>
> 
> So, we definitely need splice to/from DAX enabled inodes to be
> rejected. I'll have a look at that...
> 

default_file_splice_read uses kernel_readv which I think might actually
work. Do you know what xfstest(s) exercise splice?

Thanks
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
