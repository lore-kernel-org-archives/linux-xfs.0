Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B4CD7FCA
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 09:43:41 -0600 (CST)
Message-ID: <5130CCAE.2060108@sgi.com>
Date: Fri, 1 Mar 2013 09:43:42 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfstets: fsstress add replace file operation
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-5-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-5-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> The most common usecase for rename(2) syscall is an atomic replacement
> of existing file with newer version. But rename_f() rename some existing
> filename to newly generated (non existing) filename. As result the most
> important usecase is not covered.

Good catch.

> Since rename_f() is already exist in fsstress and it has known behavior,
> some tests already depends on that behaviour, let's add another operation
> (replace_f) which invoke rename(2) for two existing entries.

>
> OUT_OF_COMMIT_DISCUSSION:
> Off course replace_f() break naming convention where fun_name == syscall_f(),
> but this is the only way I see to introduce new feature and not break
> other tests. May be it is reasonable to call it rename2_f() ?
>

I think this possible exposes a bug which was not exposed by before when 
running for example test 076 and test 083 on both ext4 and xfs.

Suggest this new function is called rename2_() so that we don't change 
the existing known tests.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
