Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC3E13B5A0
	for <linux-xfs@vger.kernel.org>; Thu, 13 Mar 2025 08:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741855525; cv=none; b=PAj9IFwlPpxbWIDzr2P7wMOqItkjYizYsQbASoH0KPD9jdREU4lmVDyGeRl/RWVn8uKAjRIoRfIYrNxom1QGd6gRDAdDGi18VvDNDtaZymYNoNiePWD77QPPij1xi0tqvGmGh+Y0zRcFQOfOVQc7hvHMiT1750ui8PIXGgEGyFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741855525; c=relaxed/simple;
	bh=H79xmv6faUgxxXF4n8Qx7iWPcvcG+oWo2TXTfVecduw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tlHg0TN10tjFyawhos0auvOBE2PBPbKTed6l6M7tbhSPfrQp//5GWuJ/4EGsZ9gkE7YImrVpc32Wi++Jd+HdGLFtUkDfJ5aZhgiL89tn+QBMYrjVRYqbWwgo3h11ZSLLFcMmINCGQY6sWE97Q8Fbbg5oUxWrXLWIyumLPbE0KIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF8F868AA6; Thu, 13 Mar 2025 09:45:17 +0100 (CET)
Date: Thu, 13 Mar 2025 09:45:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: allow internal RT devices for zoned mode
Message-ID: <20250313084517.GA15727@lst.de>
References: <8bf5094d-8e92-45d5-885d-71369fe4aaa2@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf5094d-8e92-45d5-885d-71369fe4aaa2@stanley.mountain>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 13, 2025 at 11:42:31AM +0300, Dan Carpenter wrote:
> Hello Christoph Hellwig,
> 
> Commit bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
> from Nov 17, 2024 (linux-next), leads to the following Smatch static
> checker warning:

Yeah.  I'm pretty sure you reported it before and I thought I had fixed
it, but I guess that got lost again somehow.  I'll take care of it
and thanks for the reminder!

