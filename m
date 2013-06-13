Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0384429DFA
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 12:53:20 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF291304064
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 10:53:19 -0700 (PDT)
Message-ID: <51BA0710.8050108@sgi.com>
Date: Thu, 13 Jun 2013 12:53:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: fix the symbolic link assert in xfs_ifree
References: <20130613170449.144027450@sgi.com> <51BA065E.8010101@sgi.com>
In-Reply-To: <51BA065E.8010101@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 06/13/13 12:50, Mark Tinguely wrote:
> On 06/13/13 12:04, Mark Tinguely wrote:
>> race_xfs_readlink(ip);
>> +
>

Augh, one of those days - oops I got the wrong trace in this version of 
the patch... should be trace_xfs_symlink_inactive(ip) added in xfs_trace.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
