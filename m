Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 963E729E2B
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 11:54:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C3CC8F806F
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 09:54:13 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id HQF9Wgo3sKYgsSqa for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 09:54:11 -0800 (PST)
Date: Wed, 6 Nov 2013 18:54:06 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] xfstests: add regression test for running btrfs
	balance and defrag concurrently
Message-ID: <20131106175406.GB16662@twin.jikos.cz>
References: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
Reply-To: dsterba@suse.cz
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
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 05:34:22PM +0800, Liu Bo wrote:
> The test aims to trigger snapshot-aware defrag path in write endio by
> running balance, which is not expected and leads to a crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
