Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 991C47F9C
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 18:55:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 27BE6AC002
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 16:55:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EfiKiGJtImDxlVCz for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 16:55:02 -0700 (PDT)
Date: Sat, 4 Jul 2015 09:55:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Message-ID: <20150703235500.GR7943@dastard>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
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
To: Rasmus Borup Hansen <rbh@intomics.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 03, 2015 at 08:27:28AM +0200, Rasmus Borup Hansen wrote:
> Thank you for the suggestion. I compiled a new xfs_repair, but I got similar results from running it.

Please take a metadump of the filesystem before and after repair
so that we can find out what is actually going wrong. Feel free to
send me a private pointer to the metadump images...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
