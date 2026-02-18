Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CFE2EA468;
	Wed, 18 Feb 2026 06:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771397471; cv=none; b=DAajaMCwJAI4RYyTdOpjiAnLpWOdXEpYgvrwdFIRi7weMKI7OILHelPNw/OjUq89HyoPNhdCe8DqF8JExEHQXnXigqKDK7bAaOSNsgWjwE09I9WbriTj+o5T7N4xlx/3gjr9jxahd5vmjvW6909nRWF0SkrlzfoFv34cVmW2hx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771397471; c=relaxed/simple;
	bh=F3VnCrUrf9yHTiQHIXJE957tzuSo+zpTKMVQIj1b6Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5poAwbH/3cVQdbXQZPGOxLeHPaaZsuTW9IiplGNY4IPumraSZfe4iL1ELgxNDCE6j5+mtiXG87wjWFKQbQcV86Wf7diAL1xehnzmutW3kQVrlnTYDb12H1hbeAZqoDGhsxOs18wYeyERfKwhD2CyPDylVWi8XTxEKPr/4LVZyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94FE868B05; Wed, 18 Feb 2026 07:51:07 +0100 (CET)
Date: Wed, 18 Feb 2026 07:51:07 +0100
From: Christoph Hellwig <hch@lst.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Andres Freund <andres@anarazel.de>, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218065107.GA9019@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <20260217055103.GA6174@lst.de> <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 17, 2026 at 10:23:36AM +0100, Amir Goldstein wrote:
> On Tue, Feb 17, 2026 at 8:00 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > I think a better session would be how we can help postgres to move
> > off buffered I/O instead of adding more special cases for them.
> 
> Respectfully, I disagree that DIO is the only possible solution.
> Direct I/O is a legit solution for databases and so is buffered I/O
> each with their own caveats.

Maybe.  Classic buffered I/O is not a legit solution for doing atomic
I/Os, and if Postgres is desperate to use that, something like direct
I/O (including the proposed write though semantics) are the only sensible
choice.

