Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4BD2741D5;
	Wed, 23 Apr 2025 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745393442; cv=none; b=doG3erJz2XroR4U+oxjNaJPkTZGuEjDJi6Mo9YqKI5cP4Op0jojXHONe9od5WHUNnoKP6mR79O6hcXGZywXl/P5LT6xNGav9awmNvqKZF1YEh+QIw7k/18pcX8wfY6aSK7ZzDgMp94zJgHgEGmKLey+iL2XbuOznUfqx124ArcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745393442; c=relaxed/simple;
	bh=HZRYRCV3pXnH6mdLHlJbBbonz669nVLcSkwX4WuVk9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzsRrM1QWlOuFaUoHpZA0AMEvyxUUJx0XCzgPwxOjF5GWGbk0qPPFvX78lBMo3E8nuK3hkVwSu0peE0ZlGihK/s+vfOsmBiYHRcXmGWFKVuV3rQW2lLAOahYjugXwTJJA8d4FmAqviU3fb4ATaVB06Z/TqLt3IDOC7BCphwGWek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMgd2C/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMgd2C/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AB8C4CEEF;
	Wed, 23 Apr 2025 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745393441;
	bh=HZRYRCV3pXnH6mdLHlJbBbonz669nVLcSkwX4WuVk9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMgd2C/EoxuVOUJ44YVL8CqVz2U186QceBQy1SZFk/H9Hvbb41O8RUFvb/ihIlZ1g
	 lQ+8Cp8pJGO8mB6RgrPjfc72/xEtChIQD0af7NGc2jjqOuz0BIqaYdLi2NjfiMueAM
	 4DjPCfOwlwomfKqROJn7MNH4R3BeBAI39Ut5HdKw=
Date: Wed, 23 Apr 2025 09:29:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Yang, Zhi" <Zhi.Yang@windriver.com>
Cc: "cem@kernel.org" <cem@kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"llfamsec@gmail.com" <llfamsec@gmail.com>,
	"He, Zhe" <Zhe.He@windriver.com>,
	"Chen, Xiangyu" <Xiangyu.Chen@windriver.com>,
	"amir73il@gmail.com" <amir73il@gmail.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"dchinner@redhat.com" <dchinner@redhat.com>,
	"chandanbabu@kernel.org" <chandanbabu@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5.10.y] xfs: add bounds checking to
 xlog_recover_process_data
Message-ID: <2025042345-enable-economist-b5b6@gregkh>
References: <20250423021325.1718990-1-Zhi.Yang@eng.windriver.com>
 <2025042340-delicate-stubbed-218e@gregkh>
 <DM6PR11MB3324E74F9DF280B6E13914619FBA2@DM6PR11MB3324.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB3324E74F9DF280B6E13914619FBA2@DM6PR11MB3324.namprd11.prod.outlook.com>

On Wed, Apr 23, 2025 at 07:24:41AM +0000, Yang, Zhi wrote:
> Add xfs stable maintainer.

That provided no context at all.  Please do this properly.
