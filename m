Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D91BA7F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 15:54:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7B30304048
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 13:54:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NAVtheAUvvfNBDnk for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 13:54:41 -0700 (PDT)
Date: Tue, 23 Sep 2014 06:54:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfs: add unicode character database files
Message-ID: <20140922205438.GM4267@dastard>
References: <20140918195650.GI19952@sgi.com>
 <20140918201440.GI4482@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918201440.GI4482@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 18, 2014 at 03:14:40PM -0500, Ben Myers wrote:
> From: Olaf Weber <olaf@sgi.com>
> 
> Add files from the Unicode Character Database, version 7.0.0, to the source.
> A helper program that generates a trie used for normalization from these
> files is part of a separate commit.
> 
> Signed-off-by: Olaf Weber <olaf@sgi.com>
> ---
> [v2: Removed large unicode files prior to posting.  Get them as below. -bpm]
> [v3: Moved files to ucd8norm directory. -bpm]
> 
> cd fs/xfs/utf8norm/ucd
> wget http://www.unicode.org/Public/7.0.0/ucd/CaseFolding.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/DerivedAge.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/extracted/DerivedCombiningClass.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/DerivedCoreProperties.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/NormalizationCorrections.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/NormalizationTest.txt
> wget http://www.unicode.org/Public/7.0.0/ucd/UnicodeData.txt
> for e in *.txt
> do
> 	base=`basename $e .txt`
> 	mv $e $base-7.0.0.txt
> done
> ---
>  fs/xfs/utf8norm/ucd/README | 33 +++++++++++++++++++++++++++++++++

This probably needs to live somewhere under lib/.  There's nothing
XFS specific in it and the translations should be the same for
anything that wants to parse unicode.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
