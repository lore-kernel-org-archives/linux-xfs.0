Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0AF136663
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 18:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462736; cv=none; b=HMX7KjBIZ4xnr8HuijdzDSUpd+tfxTuTySyy6eM/jk4CSLYHxOVbyLmRqo9O7UdNvfMjtvyr4a4tMQNZ8hjGdcxYc61y5Fgt8fpkdzss/S9k4cOtO34T86XxPZ6eId0hRI9pwLFcBPBCR1pGs23rCKcmzXptT9+MKKlgSIP6i4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462736; c=relaxed/simple;
	bh=UbNun1NRKf/oU7a7Cp2I/mkwjI8YVp+hCP5PPeJ7aYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=NgGs0TassPYPa8iYIQHjw+B/9iPvXRMssVGLY4dpGMIk892MgCv0/xVPaiuNIjcvQ+4ni2QJIIIDd2pjaiAcVXQ0OgCslrPHjofhdtxXD9TuDWERZtn7X+HUtzrvPUJAr91vwnckEiTxl3A7gykXl0G3IhdO8Co03qD944Bi91Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eml1HHpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eml1HHpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75710C4CEC9;
	Fri, 27 Sep 2024 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727462735;
	bh=UbNun1NRKf/oU7a7Cp2I/mkwjI8YVp+hCP5PPeJ7aYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=Eml1HHpbbxj/VxlVERD64Pds+DLVUaDZh4D8l/S2yLwtnxai8mUzrLgFHewC4vtKC
	 iYYgLb3+eVoAzZxvcYWs+h9caLV9xgU4HK7YRRopelPaqscjSpuVz9dNF/KfmcbX19
	 ZiU3kTzxRCwuiD1uSzd2IszWUnTdYoGBUdlpa6DJPl3GZRIK5qua6C4wThR+Ztjyd5
	 fOanojqX0+9sIaqQImJgRRA8KUQI0tstVOsAPbuEKjRQffrAgDgWJmoRRxJMjTNMJu
	 hcmkmpSkoyLF6oKTsdv6bZNsYh+rfcpsbGzagB8Bkp+wPUWtA8zcbSZnY0BsbXLVch
	 7DERfqG4DkzUg==
From: Carlos Maiolino <cem@kernel.org>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org, 
 Zhang Zekun <zhangzekun11@huawei.com>
Cc: chenjun102@huawei.com
In-Reply-To: <20240906060243.4502-1-zhangzekun11@huawei.com>
References: <20240906060243.4502-1-zhangzekun11@huawei.com>
Subject: Re: [PATCH] xfs: Remove empty declartion in header file
Message-Id: <172746273414.131348.3767602780741482976.b4-ty@kernel.org>
Date: Fri, 27 Sep 2024 20:45:34 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1

On Fri, 06 Sep 2024 14:02:43 +0800, Zhang Zekun wrote:
> The definition of xfs_attr_use_log_assist() has been removed since
> commit d9c61ccb3b09 ("xfs: move xfs_attr_use_log_assist out of xfs_log.c").
> So, Remove the empty declartion in header files.
> 
> 

Applied to xfs-6.12-rc2, thanks!

[1/1] xfs: Remove empty declartion in header file
      commit: 4cf4f2fca988b2aefd76bef8bcedd4e752387537

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

