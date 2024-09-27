Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B8F8475;
	Fri, 27 Sep 2024 08:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727424040; cv=none; b=Gsb5Zjc2scX3FFjhv5cqp07EY7Udx0eYUQMhvWqAQX7lAwNO0LXuZDoOcCQDh6ehFLfKYEJB33EEPoIMLMQiuRTbDpk3aAuy+Equ0/6RQGNpJ/bj4BFtI4ckStr7jPJPxCUQj1wOMnQJ9uh7gsG1N2rfO2yJOmVLD+bg2XtXVgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727424040; c=relaxed/simple;
	bh=POiDnx7nVru55EBjQLUzW3zhzhF8TY23DF2hq8RG3Iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3g9w4Lvmc/EVpr/zUTqk8rQL2B5tCHP9jEACn8ewLi6A+o7UbfvmToVNtmGYfEiI4gpvSxWP64sRqC9MhhkSg0Lc44pbVEAr9VommPtqnJqULSS0+CkL+U1JQYRCFOlkVq2mS2YFz7U+s00R3DQMXu7fr6HKfdj4mw41TRPb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK6+ytWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK6+ytWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBE9C4CEC4;
	Fri, 27 Sep 2024 08:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727424039;
	bh=POiDnx7nVru55EBjQLUzW3zhzhF8TY23DF2hq8RG3Iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vK6+ytWizi8IyVUnXXeYkp2CBUQUefvEldmhw4nVApdbqgl4DqA/Y5lmCDCJi+R0V
	 ItTlqbxQ/EL8i07eT9hWSC817+hmKOmuenJrADKNLkD7prK2zDmcquwMsFteWOQmu7
	 zlpdsDNvgTxP/xNtmoFkb/1zxwH8UVaLYsh4QKRc=
Date: Fri, 27 Sep 2024 08:52:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kuntal Nayak <kuntal.nayak@broadcom.com>
Cc: leah.rumancik@gmail.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com, vasavi.sirnapalli@broadcom.com,
	lei lu <llfamsec@gmail.com>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH v5.10] xfs: add bounds checking to
 xlog_recover_process_data
Message-ID: <2024092725-chamber-compel-10b5@gregkh>
References: <20240924223958.347475-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924223958.347475-1-kuntal.nayak@broadcom.com>

On Tue, Sep 24, 2024 at 03:39:56PM -0700, Kuntal Nayak wrote:
> From: lei lu <llfamsec@gmail.com>
> 
> [ Upstream commit fb63435b7c7dc112b1ae1baea5486e0a6e27b196 ]

Also, what is the ordering here?  Should I just guess?
