Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE9E48424D
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791468898; cv=none; b=qvOdi9BLzjCEUXeCL2Zo5dt8mDs3vKcwu17/Y0dk5eJpeuz0FCRFUNbgytz+HzdwQbEZe1pJHxIihScsbqCpvcUa4glrvIOsRKeViAJ9xZl0n0gEx7h5avnUPvEQGcM5MkcHwByuzyLf9+h64wGemIcD/hiJ4vACSMvl48mW9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791468898; c=relaxed/simple;
	bh=ihuCT/WoaAJVi2FVFElvl5JV8SW4gtk0vH684/lT9Jg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LCii5wnlhj5tBGxc5SYGUAA0Mja1Ov7rNLQkIBl0ckD1S+BVuEDBHparo6IeLJkjyG1TgYFaYJmlAtbADAmiUrb0wvUXwhJjbGNc3qe6haAVOzIXV0kXWNSg15FmRTBUNgfgu2q90na+QDIoL1mq/rO/i+IWoA5BVkmdUCW3qqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFz1C8vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFz1C8vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055591F00898;
	Thu,  8 Oct 2026 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791468897;
	bh=2wrX9bZfwtrbVz5vfOCAtD2YLDUI4sIu3h54wigcM0k=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eFz1C8vlzk++WVBHoSVqGk4zs19fNfo02GWJD3CsM3TUqbKZnI1Ur/d0b3FX0hCXy
	 hrGm0I9gpT2cUm5rv0B0gfwX3K92rdzJ3HGw6oZ3NCGn/Wtq1gQSWGO4kKgIOmlnWz
	 TMIzlJcACq6qdAX0AYZIFs/qrHK6BxXznzUBxkOdDBz/P2WO/L3V/F0i9FTl4GwR7M
	 f0/pb46Fusw3J9iQ7InlhUQpxessBon4EmebWdSK6Mqm7XC+ZrPmkij3CjUmkIWV1k
	 iSxIi70i/NVVx+SbVIIe2QycpGIM+cjH6P9YYqNJuEMouvXqNozuveXV2EGCMT/xgV
	 0eiNv3+H7BvuA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 51949F40067;
	Thu,  8 Oct 2026 10:14:56 -0400 (EDT)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Thu, 08 Oct 2026 10:14:56 -0400
X-ME-Sender: <xms:YKXHau4MKFQaAdrcxY49Pk-OrldkcgnNr5e-MmvPeQw9q8y4fzBegA>
    <xme:YKXHaispovt7K-e8ccjTWN8fmd0oonHnperrrm0dLOzeRWD9-IbsSgYUdzsCDoYJv
    TNO0rvytTiUTouVirDno9E_dg2UfS0OcXQxcBiUCM2k8sG_GCpJ8JZc>
X-ME-Proxy-Cause: dmFkZTGP2BefX+1O59ue/WIwQQDv5JsRAvknKxPw3WIVABtaL3rU/DzYhhnxMwzLSTXgrN
    gADUuKL0wwKeLCTEhKg4c+d/hhVCaWDPMiLg5boZLmNEHOvZ91dIxAkEvROU+LKYuNK3EV
    VI/8xkz64PfV1hmX660lxxOETQ9FEhyklkY5avs013pn04pqsF7SkuLzUyGtw5kuv9GoQr
    I11oySD3kqsbmT3HTp41EXrHShW+GyTIm2+xv+rRx4+UFrP48HVUNTduCTav1H08pvjDkB
    z0T5wZcn5iNRiUNeVoliAIAkSFcfNEkNwxLjOB+tc6byhEPRWbZV1Ub4ukiVeURBHaQMKu
    aX3zRd+58IuU73yInTrSrhH+kDdpOEoLMExJAkOkzFfAXaBR7zKAE9wE3z/dyUZ/4coMI1
    bn5qBhdwNcOWw0q/X717qIDXDOeTWtN+DO4HvWpDun8V36j0wXoZjLYIQbhufuJ39Z7KOi
    RrNUsKIFzLVcpoChDYt/pIrPfgqrCIk793TtiEZEL+VBVqRhLIEKEBzsjnMiB/yMPucyeW
    0t4NSSeTrrOcOtW2pyCgfDKXu4t/jLNDygj5tdX4ECmkaLd6+gPpRnFXWlaseSso5iTw5u
    gq+FXSZy5XL16/s2VdVWyEnnUdBLFRyjjo90LDmKH2pSVCR9GauOm+dMkHoQ
X-ME-Proxy: <xmx:YKXHar2eN6VxKGH0qZ_Apj5JfyG1PcIHXnW5FsN1MWa3_nYNCfT4Tg>
    <xmx:YKXHah9vM6g0sDdSziO8p67DnXDrLw6hDsPmrsysLX6LB3Mpgfw25A>
    <xmx:YKXHarSJA9oxG0LN_jR__MgIib79RbmSkTGj0qhwAL_yXnAjpOqVpg>
    <xmx:YKXHaonheh8kGRKFb43kVDyutnHgXZWAOLnT7EMID3-pk1Gf_MKd1A>
    <xmx:YKXHamVbxWVY57upfxOU-OryarX7i_SqVajod_AkiA6oRtG0AAWtdwML>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 16530780070; Thu,  8 Oct 2026 10:14:56 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AzMKWkPV1-Ok
Date: Thu, 08 Oct 2026 10:14:35 -0400
From: "Chuck Lever" <cel@kernel.org>
To: "Daejun Park" <daejun7.park@samsung.com>,
 "Darrick J. Wong" <djwong@kernel.org>
Cc: "Jeff Layton" <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
 "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo" <Dai.Ngo@oracle.com>,
 "Tom Talpey" <tom@talpey.com>, "Christoph Hellwig" <hch@lst.de>,
 "Sergey Bashirov" <sergeybashirov@gmail.com>,
 "Carlos Maiolino" <cem@kernel.org>, "Amir Goldstein" <amir73il@gmail.com>,
 "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <e80265ff-322b-4a52-ba51-393e3e4f503e@app.fastmail.com>
In-Reply-To: 
 <20261008014706epcms2p7f60dc9a1db6ca16a6fff03de67688c2e@epcms2p7>
References: <20261007165101.GD2705364@frogsfrogsfrogs>
 <20261007-nfsd-block-trim-v1-1-53370f97047a@samsung.com>
 <CGME20261007165105epcas2p264fc1fd07bab1fb877a6695062f48322@epcms2p7>
 <20261008014706epcms2p7f60dc9a1db6ca16a6fff03de67688c2e@epcms2p7>
Subject: Re: (2) [PATCH] nfsd: do not return overlapping extents in a block layout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Oct 7, 2026, at 9:47 PM, Daejun Park wrote:
> On Wed, Oct 07, 2026 at 09:51:01AM -0700, Darrick J. Wong wrote:
>> Nitpicking here, but the extent could extend beyond than the requested
>> @offset/@length range too, right?  Shouldn't the comment say that, since
>> the header comment allows for both cases, right?
>
> Yes, it can end past offset + length. Chuck had already applied the
> patch to nfsd-testing (214e388464bf) when your reply came, so the
> comment there still says "may be shorter than the requested length".
>
> The ->map_blocks series that Christoph asked for removes that comment:
>
> https://lore.kernel.org/r/20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com
>
> nfsd4_block_map_extent() becomes nfsd4_block_iomap_to_extent(), which
> only converts a mapping, and the ->map_blocks comment says that the
> last mapping may end before or after @offset + @len.
>
> If Chuck would rather fix it in nfsd-testing in the meantime, the
> comment would read:
>
> /*
>  * Get an extent from the file system that contains offset. It may start
>  * below offset and may end before or after offset + length.
>  */

I don't quite understand the logistics / ordering, as it appears to
invite a conflict depending on which tree the ->map_blocks series
goes through.


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
