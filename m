Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4150B4968EE
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 08:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792397609; cv=none; b=kVDfDgOtfU2FFp1n9c30/y09XupIZWQAGe+3sJOOFh5eC15ZAAl8XhB1AA7Gpy+dkDfs/v+HzyoikYlSv5Bzm0WlmOmpEotfQjgh0X1B7GqwYlMjGksL5NtoVbO0tGH7K8ct8setPxcX7n8ruQhGuvCIAO0+RYmSDFxPOFuilQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792397609; c=relaxed/simple;
	bh=OWz1+lDhv78j34EQVo601rm5S0w9vZ5Rw1fb53wYij0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGeEypginMoQse0Gtsgbg7YHLT7Z44lGgQVfyWwxL3oUi0o0Ya3yP7suOo3FKz07l/s8C1afCkC39Sv7oEwJwN201CqtFdaoQRIe93TuyN+/fuEO+guGyJAcN7Bn7M96C5+szaIrAjIU8X/txh/hP59LkaUTs8a8rfdNJMUwKmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=avQCacR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="avQCacR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466651F000C4;
	Mon, 19 Oct 2026 08:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792397608;
	bh=8S3voKs4SYqJ4KsJ4A1g8WC0vjJGsSHbAkdAKFj4mdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=avQCacR7CVF2p9srtuBt7Zd1QAWiPCJdXRkUnlb1EGYTuneeqsb0afgAuc8TBIOex
	 YT0yu7eBoIsTeTKYaLDD2CGLwlrXWMT4l6kK8TcqN2e6FtxK/ObPkLlIT9xNlsFfeJ
	 B9kftWrQz/9rdtwRAJvQJ3sqpCl5sMVPMuzRq33UzsgVyGYPW2zh0MxPfbKk/Xvndc
	 8rJig8WI/bFebBBBs/X9XCwoqQW9N/2Sn4jvtZZvCpmuktoP2A9hFRexGvkB80NJgP
	 gA1DBlyn1NHvIoapLv4B6GKi3r9kUdleZNrfgQsVwlcCHC5IKbl7o8KviuqOXD0OL5
	 ybdmGBYzvIDLA==
Date: Mon, 19 Oct 2026 10:13:25 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] mkfs: add config file for the 2026 LTS kernel
Message-ID: <atXQ_3DgDyTYoXip@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
 <179158948318.3720929.17786050362980005785.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179158948318.3720929.17786050362980005785.stgit@frogsfrogsfrogs>

On 2026-10-09 16:53:26, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a config file for 7.3 since it'll be the LTS.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
