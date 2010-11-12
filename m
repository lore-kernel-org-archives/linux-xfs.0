Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNNWoj171553 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:23:33 -0600
Subject: Re: [PATCH v2 2/9] xfsrestore: change nrh_t from 32 to 64 bits
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163643.341036303@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163643.341036303@sgi.com>
Date: Fri, 12 Nov 2010 17:24:44 -0600
Message-ID: <1289604284.2315.902.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> plain text document attachment (namreg_64bit)
> An nrh_t refers to a byte offset in a file containing all the pathname
> components from a dump. At an average filename length of 20
> characters, an nrh_t would overflow on a dump containing ~214 million
> directory entries. Removing this limitation allows xfsrestore to
> handle 4 billion directory entries.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
