Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7F0AD7F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 10:10:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D8A38F8050
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 08:10:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Le57LEAZjFKvBvMv for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 08:10:23 -0700 (PDT)
Message-ID: <525EAC5F.3040201@sandeen.net>
Date: Wed, 16 Oct 2013 10:10:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: jbacik@fusionio.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following GNU/Linux kernel patch:
> 
> https://patchwork.kernel.org/patch/3046931/

Hi Filipe, thanks for the patch.

Usually we don't want to add new, possibly-failing cases to old tests;
that makes it harder to identify when the code regressed vs. when
the test changed to test new things.

It would be better to just copy the framework of tests/shared/051
to a new test in shared/ and test only this new inheritance
problem.

Also, I'm confused about this hunk:

> @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
>  getfacl --numeric largeaclfile | _filter_aces
>  
>  echo "1 above xfs acl max"
> -chacl $acl3 largeaclfile
> +if [ "$FSTYP" != "btrfs" ]; then
> +	chacl $acl3 largeaclfile
> +else
> +	echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
> +fi
> +
>  getfacl --numeric largeaclfile | _filter_aces
>  
>  echo "use 16 aces"

What's that about?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
