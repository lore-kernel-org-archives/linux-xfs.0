Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BEC158D66
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 13:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721826981; cv=none; b=dC/hi7SveqzQtIPV///pZM2G9qo1HqTyxLj0tvckXdZWlm+Q7RiTXN+O0Oe5Q3arx6qONOydH9Vm+NfaYw92R2bViNURbdr8pRU2zZBVZ6yxVYTqDfKXj6blApWqzh8bAtvqDlUY1mtICPEMgnMagMeO1v7IwF3jAJzVMrwlhjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721826981; c=relaxed/simple;
	bh=vwuU5/W27mhZG7qDhxHHEByKdshU4BdYl5IkB3RpFhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aAPDqsGI6CsmcN7nJ/e4B+VKu1bSPrhqQSknMHBcBxrGuOBvaUN6ivKD9bcXSt1TvYE4gfiwnDO3TC6SLxqyrOkEIQ0fC908MqbKcfGwxqz3yr9HATKw3jAxTjlllFAGB/6PNpKSSIzRFZhFIANazulM1xQPLypPxS7kxj2TMOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PLY/fAWI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PLY/fAWI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JM2uS6dNBsaNtrc8epFCzkEG95FMdRRzA47r3mXpOQU=; b=PLY/fAWIBLctClQ0wfLmK9OzHY
	49A15idA6VlfiyG4dvw8F4fH89VbmdYPYfVrHzqUm+ssz+Sam42lQOZQV5qX1jhmaFrkdTNhv5tix
	bzrlcFLopeQrvYCGkSbPCgv6UfA+8h/OF5b7WmifXWTMsgWY52nN9ZNSdvTvIsYbb3VTlT0nrdkiO
	9yuSEGtOATnCTh8dlQ3RoV++HrbVavtSmKKwQhvlTVe2jaM2oXBEgiTNf5KuUOh8ZMfkof65CljzV
	1aSuuXQUAyduezeWPDjyXAaa+xqkDk14IFQaDWcrDl84czUkzyuWEVF/mb6g+y4tRaldPGxhSwPO3
	JuUDaU+A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWbqt-0000000FPwb-2ryf;
	Wed, 24 Jul 2024 13:16:19 +0000
Date: Wed, 24 Jul 2024 06:16:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub_all: fail fast on masked units
Message-ID: <ZqD-oxofZyJCj-wR@infradead.org>
References: <20240724045241.GW612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724045241.GW612460@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Tue, Jul 23, 2024 at 09:52:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If xfs_scrub_all tries to start a masked xfs_scrub@ unit, that's a sign
> that the system administrator really didn't want us to scrub that
> filesystem.  Instead of retrying pointlessly, just make a note of the
> failure and move on.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  scrub/xfs_scrub_all.in |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> index 5440e51c0791..5e2e0446a99f 100644
> --- a/scrub/xfs_scrub_all.in
> +++ b/scrub/xfs_scrub_all.in
> @@ -181,6 +181,10 @@ def fibonacci(max_ret):
>  		y = z
>  		z = x + y
>  
> +def was_unit_masked(ex):
> +	'''Decide if this dbus exception occurred because we tried to start a masked unit.'''
> +	return ex.get_dbus_name() == "org.freedesktop.systemd1.UnitMasked"
> +
>  class scrub_service(scrub_control):
>  	'''Control object for xfs_scrub systemd service.'''
>  	def __init__(self, mnt, scrub_media):
> @@ -219,6 +223,12 @@ class scrub_service(scrub_control):
>  				if debug:
>  					print(e)
>  				fatal_ex = e
> +
> +				# If the unit is masked, there's no point in
> +				# retrying any operations on it.
> +				if was_unit_masked(e):
> +					break
> +
>  				time.sleep(i)
>  				self.bind()
>  		raise fatal_ex
> @@ -270,6 +280,13 @@ class scrub_service(scrub_control):
>  		try:
>  			self.__dbusrun(lambda: self.unit.Start('replace'))
>  			return self.wait()
> +		except dbus.exceptions.DBusException as e:
> +			# If the unit was masked, the sysadmin doesn't want us
> +			# running it.  Pretend that we finished it.
> +			if was_unit_masked(e):
> +				return 32
> +			print(e, file = sys.stderr)
> +			return -1
>  		except Exception as e:
>  			print(e, file = sys.stderr)
>  			return -1
> @@ -317,6 +334,10 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
>  		# are running as a systemd service.
>  		if 'SERVICE_MODE' in os.environ:
>  			ret = run_service(mnt, scrub_media, killfuncs)
> +			if ret == 32:
> +				print("Scrubbing %s disabled by administrator, (err=%d)" % (mnt, ret))
> +				sys.stdout.flush()
> +				return
>  			if ret == 0 or ret == 1:
>  				print("Scrubbing %s done, (err=%d)" % (mnt, ret))
>  				sys.stdout.flush()
---end quoted text---
