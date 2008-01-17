Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 12:08:49 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0HK8hdj030752
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:08:45 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FEA052F78B
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:08:59 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id 3g2F8CnzT8jUPaiT for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 12:08:59 -0800 (PST)
Message-ID: <478FA832.7030200@sandeen.net>
Date: Thu, 17 Jan 2008 13:10:42 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repairing a possibly incomplete xfs_growfs command?
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253594C@pvn-3001.purevideo.local> <20080117030111.GH155259@sgi.com> <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
In-Reply-To: <9CE70E6ED2C2F64FB5537A2973FA4F02535951@pvn-3001.purevideo.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Magpayo <mmagpayo@purevideo.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Mark Magpayo wrote:

> Someone else asked for the size of the block devices... here's the
> output from /proc/partitions: 
> 
> 152     0 9523468862 etherd/e1.0
> 152    16 9523468862 etherd/e0.0


are those two assembled into your actual block device?  They look each
about 8T.

Is the lvm device also in /proc/partitions?

-Eric
