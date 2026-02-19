Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822A82AF00;
	Thu, 19 Feb 2026 00:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771461115; cv=none; b=GLG4Yg3oKUSverxNv9USgcAQ11K+uNGxbi2+EmB/OxdnJFAQTkuaUVA5Wcx4UFgA+qVgAQgiQoCtBAZz+73zNghznMAyFCNcIS3NnMhDJ1ygmlHLW/IeyHmHB2kRYfxOjw7JmT1CfTBdOfIidr+s+9IZHvOMEjcIrxgdqiIGW0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771461115; c=relaxed/simple;
	bh=W+DRCotPO+lplAvpbLsFSHe5qfhMBXPlDDZXepmzDII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPFhN6R2uayEq7Rvm+BrKmjgK7cfoZV0TXS7t4ebMKWLWcrW3EtVPOLoC+BG2G1bQoOP8MzigVOxlrcA33Gh4yr6Z/DlvtV+lKQABCeHbFxVcOf57qR/ynEKpSxrb72ST+TpXOqk0XymSXC8zkHe0T/B2/5vY0cgcdJLc0ve1So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtUg5Da8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtUg5Da8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201D7C116D0;
	Thu, 19 Feb 2026 00:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771461115;
	bh=W+DRCotPO+lplAvpbLsFSHe5qfhMBXPlDDZXepmzDII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BtUg5Da8Bf2+hnBblwrGDVnxEnEVwcJo6V0tKf702txgWTJgBX7QfWty9o7iY0TlL
	 OmktExhhXkE4kYFFFwoIcLLTSuh1v42TeOth3kqw4E50sdvywmHKBhez6brpkFLTtQ
	 yDU4/QE8MfAtsZuHdx1UqXjfKFE9PJp+48oHX6IAzfHBsrL5uKB0dYsS3/RgLDm2EI
	 zr0rZ9mfOpnX0Oj2zTkbutC8DF4Lhuu/pcCqL52Uxq54W8oyn23GD9b8bB1tdmbXxs
	 +DEy2JmKSaPrXt+pPEFJ0EVRrtsbJ6+UaaeTDdzbDVcLLQZNiqWlN2tWliLKHTWNP1
	 Eumh9Irb7zJUw==
Date: Wed, 18 Feb 2026 16:31:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Ethan Tidmore <ethantidmore06@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix error pointer dereference
Message-ID: <20260219003154.GB6490@frogsfrogsfrogs>
References: <20260218195115.14049-1-ethantidmore06@gmail.com>
 <20260218234917.GA6490@frogsfrogsfrogs>
 <177146073877.8396.8928465677585359848@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177146073877.8396.8928465677585359848@noble.neil.brown.name>

On Thu, Feb 19, 2026 at 11:25:38AM +1100, NeilBrown wrote:
> On Thu, 19 Feb 2026, Darrick J. Wong wrote:
> > On Wed, Feb 18, 2026 at 01:51:15PM -0600, Ethan Tidmore wrote:
> > > The function try_lookup_noperm() can return an error pointer and is not
> > > checked for one. Add checks for error pointer.
> > > 
> > > Detected by Smatch:
> > > fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error: 
> > > 'd_child' dereferencing possible ERR_PTR()
> > > 
> > > fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error: 
> > > 'd_child' dereferencing possible ERR_PTR()
> > > 
> > > Fixes: 06c567403ae5a ("Use try_lookup_noperm() instead of d_hash_and_lookup() outside of VFS")
> > 
> > Cc: <stable@vger.kernel.org> # v6.16
> 
> I don't think this is justified.  In this use case try_lookup_noperm()
> will never actually return an error.

Sure, but a future update to try_lookup_noperm that *does* introduce the
possibility of an ERR_PTR return could get backported to 6.18, at which
point this code is now broken.  I think I'd rather just clean all this
up all at once.

> > 
> > > Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> > > ---
> > >  fs/xfs/scrub/orphanage.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> > > index 52a108f6d5f4..cdb0f486f50c 100644
> > > --- a/fs/xfs/scrub/orphanage.c
> > > +++ b/fs/xfs/scrub/orphanage.c
> > > @@ -442,7 +442,7 @@ xrep_adoption_check_dcache(
> > >  		return 0;
> > >  
> > >  	d_child = try_lookup_noperm(&qname, d_orphanage);
> > 
> > "Look up a dentry by name in the dcache, returning NULL if it does not
> > currently exist."
> > 
> > Could you please fix the documentation since try_lookup_noperm can
> > return ERR_PTR values?
> 
> Fair - I'll include a patch with my next batch.
> 
> > 
> > > -	if (d_child) {
> > > +	if (!IS_ERR_OR_NULL(d_child)) {
> > 
> > If d_child is an ERR_PTR, shouldn't we extract that error value and
> > return it instead of zero?
> 
> This is a purely cosmetic question as no error is actually returned in
> practice.  So whatever you feel most comfortable with is best.

If we're going to check for an ERR_PTR value (even if one cannot
currently be returned) then we should pass it upwards.  We might as well
get rid of all the lurking broken logic all at once.

--D

> NeilBrown
> 
> 
> > 
> > --D
> > 
> > >  		trace_xrep_adoption_check_child(sc->mp, d_child);
> > >  
> > >  		if (d_is_positive(d_child)) {
> > > @@ -479,7 +479,7 @@ xrep_adoption_zap_dcache(
> > >  		return;
> > >  
> > >  	d_child = try_lookup_noperm(&qname, d_orphanage);
> > > -	while (d_child != NULL) {
> > > +	while (!IS_ERR_OR_NULL(d_child)) {
> > >  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
> > >  
> > >  		ASSERT(d_is_negative(d_child));
> > > -- 
> > > 2.53.0
> > > 
> > > 
> > 
> 
> 
