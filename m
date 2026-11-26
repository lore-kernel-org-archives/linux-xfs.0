Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795712880;
	b=GESqUnsj2EmMbb7MqUWi/8UZjvDvX5h9tsWLALm/HYKKTkpO6yonKi3gX+Ta0eYexl1c
	 OBd0vMmKyxQEf42qdYsCQ/8WaobsPHri7oArb5dYOi35S5198AhndiXjYTFq5cELbSyJa
	 sb7Uc5QRYmmyD3gOPdVw8TXHq5yEo1sGdHBJTeVvLlwWELIAR1aOv211VWQa5Xbvg5yYn
	 p0sC9uvO+8Uy+CTevP3UyzEwrDFOn5SfpyCTiEHu9gOqXqIuk3eKaLz9eHPeUsJzCfaCr
	 WpO7eAtW1lMPQKmVRhC62DiIejoit8AsDY04nOC9gv2oRMuBkPBWTLUKELxdt/hIi9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795712880;
	h=Received:Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=DCPMR2NoL3eVXyLOQ3LfeVOgczE3s3XLXPsmHIJnF0I=;
	b=yc7DrVECON/WBYARCPqhBTglZUkTe7s3wOCSXg926kQPC37UoENrJcxt/T0K9Uscji3m
	 w5BePCJRGhxxHQoObgGW0RMTqT9h9akaaBxM9xAl2+JNoB1Edqei3EI/LjVBLi4zpbI/w
	 o3ixbpwFUjspVYvbzHIc36qKK483b2HIfbRB3A8SW/4QVFc7QdI6qAfvQgX+/EE2dRrPz
	 VV2i83DmcGOYfgCvmryNTnrCR19SXaG/TUy9DDDStFTq/Sm8sxl6z9iwrXoslRS+PPXhf
	 fWj8TXbS1RaDuCdtRUCZmXJxqF1CuKmpQuS5tfIQZk9VPFHtEuZM+giJnza7Xd37i2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23922606A31E;
	Thu, 26 Nov 2026 17:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317D01F000C0;
	Thu, 26 Nov 2026 17:07:57 +0000 (UTC)
Date: Thu, 26 Nov 2026 18:07:52 +0100
From: cem@cronus.toxiclabs.cc
To: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: what should we do about xfs/136?
Message-ID: <awhnJFLXSlENIm7y@cronus.toxiclabs.cc>
References: <awaK2LnBPb8f36Ig@infradead.org>
 <awae4V7kaESFV-NW@cronus.toxiclabs.cc>
 <awhALVy4OUef4ZNC@zlang-mailbox>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhALVy4OUef4ZNC@zlang-mailbox>

On Thu, Nov 26, 2026 at 10:27:34PM +0800, Zorro Lang wrote:
> On Wed, Nov 25, 2026 at 09:40:33AM +0100, Carlos Maiolino wrote:
> > On Tue, Nov 24, 2026 at 11:14:32PM -0800, Christoph Hellwig wrote:
> > > Hi all,
> > > 
> > > I stumbled upong xfs/136 because it is the only test in the attr2 group.
> > > It also isn't in any other group, and takes more than 25 minutes and to
> > > run in my usual test setup, and then the output doesn't match the
> > > expected one at all and it fails.
> > > 
> > > It goes back to:
> > > 
> > > commit 7dcf3ce6f95603965b51c53d0a48864b0c6e8268
> > > Author: Tim Shimmin <tes@sgi.com>
> > > Date:   Tue Oct 17 06:10:19 2006 +0000
> > > 
> > > and apparently wasn't run much at all for a long time.
> > > 
> > > Should we just kill it?
> 
> Hi Christoph,
> 
> I'm fine with that. This's a xfs specific test case. If both you and Carlos
> agree and there are no objections on the XFS list, I can go ahead and remove
> it directly for you, or feel free to send a patch for review if you prefer.

This sounds find to me :)

> 
> Thanks,
> Zorro
> 
> > >
> > 
> > Sounds good to me
> >
> 
