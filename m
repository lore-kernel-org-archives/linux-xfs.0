Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AED727F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:22:13 -0500 (CDT)
Message-ID: <52378494.7000406@sgi.com>
Date: Mon, 16 Sep 2013 17:22:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfstests: add d_type checking to fsstress
References: <52377E50.3040907@redhat.com>
In-Reply-To: <52377E50.3040907@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 09/16/13 16:55, Eric Sandeen wrote:
> This patch adds a "-D" switch to fsstress so that every time
> we call readdir, we stat the dentry&  compare it's st_mode
> to the d_type.
>
> If -D is specified only once, it ignores DT_UNKNOWN.  If specified
> twice, it considers DT_UNKNOWN to be an error.
>
> It skips paths of "./." and "./.." so that we only look at files
> newly created within the filesystem.
>
> This could be used in an xfstest; it's noisy on a failures so
> would break expected output.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> fsstress doesn't usually do validation, but it's such a handy
> framework for creating a ton of random files, this seems like
> an ok place to put it.  What do folks think?

I tried v5 and v4 with and without inode fields in the directory.
This looks good to me. Like the 2 levels of the test.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
