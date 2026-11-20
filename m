Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795199006;
	b=g5hUiC+tYCL5GuLLOwtslItkYrdjhJRBlFT4dU9TlTFn0NtxblJ70r+7eIxWWJlXqUAq
	 r7QDAMX3GLJekOLUCDmLckhH0pYi4AU3t7tLT5p0fJnP7foGzEfEtpzmojaXDWhXhXgvQ
	 PbfIIXYcTpTg9XtQZBiK5pE5HJvwOYb/KYB574+HamSEBrpRcWabC/BhUeWNlLJPstnB5
	 kjJoKt6myMQNTsuo5aLIadR1DR5zK0q4OVD/SkDcBbXxqnsZm/xjpQWob3VMIK8thFJS8
	 5ehPocGMZJaWRHWZ7yL23UNIZHz3+g4myavawTzN1k7l1fgKE4nsrdbZO1EgZ0G0rJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795199006;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=nQsZvcsGL2fDbr5otkY3ZwEAI69K0pyeUkOEGnT1zds=;
	b=OGBN4goTtslGAFdTj132ZoYmj9YsYEoKxUKhWa4DUZzIhznxAwuRIdviNVWJMlI6Atvn
	 /4tkOcxQH87gUHxUZVSjP8JTzHDHBIiXUQu8Jwpb6iQcxlCOPrvL7rFW3DBS5Coj8rfu1
	 AnOoK2AqAbuFxcC3fjU2QhflcfvQJspWQFYVTE2t3U6SKISjtrM/8QXitknRoVmHYypLn
	 MI39PjJ5ILHTz9xRWHNbJ9XUclbPkPz6Cgo65jpB4Xc8XBrVZJtRIA4Ot5pKX3RPYWMdV
	 I/VHHFasdM+dXCSUd+01v38mNPBLrcLcOwa4ktFCv8ngXIgoq5M27I3v7hWJq/r7KAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C9606A330;
	Fri, 20 Nov 2026 18:23:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D8C9606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D56E76732A; Fri, 20 Nov 2026 19:23:22 +0100 (CET)
Date: Fri, 20 Nov 2026 19:23:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: glaubitz@physik.fu-berlin.de, frank.li@vivo.com, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	vdubeyko@coreweave.com, brauner@kernel.org,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v5 3/5] hfsplus: rework hfsplus_get_block() logic
Message-ID: <20261120182322.GC2183@lst.de>
References: <20261118004844.3849979-1-slava@dubeyko.com> <20261118004844.3849979-4-slava@dubeyko.com>
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
In-Reply-To: <20261118004844.3849979-4-slava@dubeyko.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 17, 2026 at 04:48:42PM -0800, Viacheslav Dubeyko wrote:
> +/*
> + * Find the disk allocation block for 'off' within an 8-entry
> + * extent record, and the number of further allocation blocks
> + * that are contiguous with it in the same extent entry.
> + */

You can use up all 80 characters for comments..

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
