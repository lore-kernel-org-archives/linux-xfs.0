Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C664717DE36;
	Fri, 18 Oct 2024 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729241148; cv=none; b=j3gAeCuvWkZ3Mp5kuMtzPfXbGd2ieFLwM+/pInNs/D1ek7e1OCLO4dlb8PxgeGEVNpOhD8f18j/0jdlx6GyWMWGz35pDK1wsnxObbVju3+h1roa8iREZ44NqfblDme2Au/6SqolnTlpoOrJKPBGFObAbqCoRTdoRic0GEqoP8VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729241148; c=relaxed/simple;
	bh=+stBVG48tk0vK5x9KIUzoZT7IhGu/7INHeiNYvhtMx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WDsFzhlU130CE4vUu4fyG99eUtQ+Ru3oErmjoFbTRTztujTZF461FaTDeOAOdiIanLDv952jCvmn4W8ZRRCQ9y3peJm9P4c6A1jkJQtJ8Tszax7XE0QOT4MerJ6ZaQEzUpkjOi0hBCRN/L70pchMm4iqYq+Dt+OKsOssC5obtsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKIYmZJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKIYmZJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A32C4CEC3;
	Fri, 18 Oct 2024 08:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729241148;
	bh=+stBVG48tk0vK5x9KIUzoZT7IhGu/7INHeiNYvhtMx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PKIYmZJFQbtsyiipVS4BAfFpCcjBh1H02EnTe8QkEyYZvJuI06eU1j9PTrRJms30o
	 XVkEziazkhjPCtiSa883ua957uJZzThO1iWti2El1LwLuZhhft2gH0mq/Qe4Yi5cup
	 pIq17rjgchc1c4W0hogf4Q81LMR7jY44PXSw5vXY=
Date: Fri, 18 Oct 2024 10:44:51 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6.6 00/21] xfs backports for 6.6.y (from 6.10)
Message-ID: <2024101838-urging-untidy-ad0b@gregkh>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>

On Tue, Oct 15, 2024 at 05:11:05PM -0700, Catherine Hoang wrote:
> Hello,
> 
> This series contains backports for 6.6 from the 6.10 release. This patchset
> has gone through xfs testing and review.

all queued up, thanks.

greg k-h
