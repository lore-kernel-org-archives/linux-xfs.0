Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11D379EE4
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841997; cv=none; b=HVlme0VlPV13oXryzGKO0ih7mbw7OUAh+0ZGTW8KvJWAQxiArSwRHe9kudCTyiGcokp8zdqM7JirnKmOjprWLt/k2DtTCzNGnvqCU6MUvU4mK3bnJY7syMrmzx3eByH8JLJWX+NFDZYOFpZ0QAixe/pfhOOLWDKN/uhhaxUkVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841997; c=relaxed/simple;
	bh=PPcMUZqJ+8eBF6jWfbaIAXthWvKpvvgUprvVrmP1w/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQ+HQ07UkNMzv+H+/5yQiQqK1ndbjurBdKYS6lxloBCA8jZRjFJ/qlE5ZCMwk4OlpVY4vrrlCI7P4b50J0Cn9IC3z3cz+nrPx7CRAbY+dj+oSGVGIxJxO4SpXmxTePUFS8DdXAgfgD+YNQc4AwXiTO3DgJ0upvJXp+IZGurnRxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mCzKRZVK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mCzKRZVK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 367291F00A3A;
	Thu, 27 Aug 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787841992;
	bh=y0lVjNbJod6EXJEYkscQiLzKF0U33ohXKhx5Xzd+a38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCzKRZVKXq7NeOsNdMuq+zNPabmxCWOsO/zxjg3MHmj6Fgn7jWiygKsr2j3HyVLzJ
	 6UqJa/SYJ134X54O7Y3rDK1sWESLiDIvwy3AjFnazNzi9k4ox43QK37RLT1tOGJfFe
	 iK5V5cLx9kxm8HDSxpRKgdp4kcuixTjr5NivohzE8l0pyyrj/aKIEVMzHEYlyoMANu
	 7gMN/W1z/FLBFqyi3L8If5j3P+LXJvPGUxScw2QwQJczOdpWhiUp3Y52OgdBWBZGdB
	 uOkHRSNiv2bgJiYbuCzMD/WymlLxJafOXjZdh/2mLZboY89hogCiCoOM49419hfLaE
	 ZxRwaXhc9PD5A==
Date: Thu, 27 Aug 2026 07:46:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260827144631.GB6072@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
 <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
 <ux7q7mg7mp32uekxtei4vrunv53opqwthv2er7gk5l2z3ztnok@mp76pxytxzmt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ux7q7mg7mp32uekxtei4vrunv53opqwthv2er7gk5l2z3ztnok@mp76pxytxzmt>

On Thu, Aug 27, 2026 at 02:53:30PM +0530, Anuj Gupta wrote:
> > +	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
> > +	if (error)
> > +		return error;
> > +
> > +	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
> 
> should we update dp's mtime/ctime after creating the dirent using
> xfs_trans_ichgtime()?

Metadata directory trees aren't exposed to userspace, why would we care
about timestamps?

> > +		/*
> > +		 * subdir didn't give us a dotdot entry, so we just give up
> > +		 * and let the repair get marked as failed.
> > +		 */
> > +		if (old_dotdot == NULLFSINO)
> > +			return 0;
> > +	}
> 
> The comment says "let the repair get marked as failed" but return 0 here
> looks like it reports success.

The repair reports success, and the subsequent revalidation sees that
the metapath is still broken and reports that corruption to userspace.
I suppose -EFSCORRUPTED here would be clearer.

--D
