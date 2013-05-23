Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 812847F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:39:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09BB4AC001
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 16:39:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	N1CJrHkZSLhCDxHM for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 16:39:27 -0700 (PDT)
Date: Fri, 24 May 2013 09:39:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: btrfs/308: simple sparse copy testcase for btrfs
Message-ID: <20130523233925.GF24543@dastard>
References: <519E4590.4080309@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <519E4590.4080309@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 23, 2013 at 11:36:32AM -0500, Eric Sandeen wrote:
> From: Koen De Wit <koen.de.wit@oracle.com>
> 
> # Tests file clone functionality of btrfs ("reflinks"):
> #   - Reflink a file
> #   - Reflink the reflinked file
> #   - Modify the original file
> #   - Modify the reflinked file
> 
> [sandeen: add helpers, make several mostly-cosmetic
>  changes to the original testcase]
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Originally submitted as test 297

FWIW, this will conflict with Josef's new btrfs/308 patch. You don't
have to use monatomically increasing numbers for the tests anymore
in the fileystem specifc test directories - you could make these
tests btrfs/00[1-4].... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
