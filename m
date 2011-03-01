Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p21KvpEI218930 for <xfs@oss.sgi.com>; Tue, 1 Mar 2011 14:57:51 -0600
Subject: Re: [PATCH V2] libxcmd: return error from cvtnum() on overflow
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D6C1322.10102@sandeen.net>
References: <4D6C075F.1010509@redhat.com>  <4D6C1322.10102@sandeen.net>
Date: Tue, 01 Mar 2011 15:00:37 -0600
Message-ID: <1299013237.2727.12.camel@doink>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, 2011-02-28 at 15:26 -0600, Eric Sandeen wrote:
> Test 071 was failing in weird ways, partly because it was trying
> to pass in offsets larger than strtoll() could accept, which then
> silently returned LLONG_MAX instead.  For DIO tests, this was
> unaligned, so we got unexpected (to me, anyay) alignment errors.
> 
> At least printing out the perror() makes this more obvious,
> but unfortunately we then get the somewhat odd output:
> 
> # xfs_io -f -d -c "pwrite 9223373136366403584  4096" /mnt/test/grrr
> cvtnum: Numerical result out of range
> non-numeric offset argument -- 9223373136366403584
> 
> Test 071 still fails, but at least it's a bit more obvious as to why.

Your change looks good.  But here are a few more general questions
(for anyone who cares to respond--not just you):
- Do you plan to get test 071 working?  (Just curious.)
- mkfs/xfs_mkfs.c and extimate/xfs_estimate.c each define their
  own version of the same function.  Do you know why?  Is there
  any reason we couldn't just have one?
- The three version of cvtnum() are each a bit different.  Two
  of them (the other two) return -1 for an empty string, while
  this one returns 0.
- I'm not sure what you meant by "non-numeric" versus "invalid"
  in call sites.
- Call sites seem to be a bit varied on how (or whether) they
  look for errors.  Kind of a mess...

Regardless, you can consider this one reviewed.  We should
fix all three instances of the function to fix this problem
though--either the same as this (and in the same commit)
or separeately.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: zero errno first so we don't pick up a stale errno.
> 
> Note:
> ... should I change all callsites from "non-numeric" to "invalid" perhaps?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
