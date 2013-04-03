Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F13F7CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 15:36:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8B730304032
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 13:36:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id HkTZL01OLaLbeFry for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 13:36:23 -0700 (PDT)
Message-ID: <515C92C6.8010506@sandeen.net>
Date: Wed, 03 Apr 2013 15:36:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] cleanup duplicates in all tests
References: <20130403173245.376605011@sgi.com>
In-Reply-To: <20130403173245.376605011@sgi.com>
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
To: rjohnston@sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 4/3/13 12:31 PM, rjohnston@sgi.com wrote:
> There are duplicate blank lines, comment hash and lines
> containing duplicate seqres= declarations, remove them.
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
> 
> ---
>  tests/btrfs/254   |    3 ---
>  tests/btrfs/264   |    4 ----
>  tests/btrfs/265   |    3 ---
>  tests/btrfs/276   |    3 ---
>  tests/btrfs/284   |    3 ---

nothing but dup line removal:

$ egrep "^[-+][a-z]" bigpatch  | sort | uniq
-seqres=$RESULT_DIR/$seq

and every file still has one left:

$ for FILE in `guilt files`; do grep -c "seqres=$RESULT_DIR" $FILE; done | sort | uniq
1

Looks good to me!  :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
