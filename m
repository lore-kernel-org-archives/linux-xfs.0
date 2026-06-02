Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C67F392C46;
	Tue,  2 Jun 2026 05:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780379270; cv=none; b=Solm1AnFVKEFeVwEasgJJ5UbtX1h9BGUZgkje1+qg6Hz7P2yGZu04BXOKTkPtgaV+HZQv2xtNioALV+VWtJLEuQb6tdgo8dQg9/F8I0FJjCn/OCxwHisEthoy4HqfvEmit4nAGgsSqB6yk4iGTCpnV6zTPAoes+viFrNIpdcWJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780379270; c=relaxed/simple;
	bh=y1rI1NHuPlxQfS+yEmKjAWz7zKQC0BO4MVwvE1LEFUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8bYVviHz0wnRlZMuuaiCxuSScjSCGzCkw8+qGyjCe9v/Dber6Fxhc4vH1lRlf53xKzp70nnFOfz8jmhWOPAS3D4Xgkal8JvUAJVMPJifks6f8xhtWXlJrzG6+I1OQdFaVwQ17We+HYJFlHghYD3b8Ofdxuzkfhs58QuQWevAJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5ACDD68B05; Tue,  2 Jun 2026 07:47:43 +0200 (CEST)
Date: Tue, 2 Jun 2026 07:47:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap
 & xfs
Message-ID: <20260602054743.GA32657@lst.de>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org> <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 10:19:18PM +0530, Ojaswin Mujoo wrote:
> 
> So this week I spent some time looking into the failure of g/457. 
> I was able to replicate it in my setup and after analysing it, this is
> actually an issue in my xfstests patch. The issue is that to verify
> RWF_WRITETHROUGH support I do a 4kb write on the fd during the test prep
> phase. However "out-of-band" write makes the actual contents of the file
> different from what fsx expected (It reads it in before the problematic
> write), causing the test failure. 

Why does this get out of sync?  One of the arguments for RWF_WRITETHROUGH
vs direct I/O was that it avoids the content getting out of sync.

