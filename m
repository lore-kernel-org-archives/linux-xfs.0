Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56534239572
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738862998; cv=none; b=ZUt9APA465u9zUW2573DbZh5knnXOrciwuHTRXzb3Rj5dMBtZC4cIobO8bEPo8Kd7szzmdtPM9DY73CmQPDkVXuPrTM57tCscRaz7LtfYOaxbnoIQ2sUV0NBNI0wIF56lgd/zyjQERNS82OpYuzM2MYhC51OLFX591/c6NLqLKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738862998; c=relaxed/simple;
	bh=MIDtZR1y3PjzaKr8zcfl8tq8955XS77PLHuHA9Uwmrw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mV5yhmJ+vtye7/7XSO9qRRfgF/3Q/WwtJ7/xNexZSp4hnohWTCWlHlTnP0c/QyctxVc8g8yQp1PXeZWdecuhyq9ALldnsc8GuJ7dDvd0gK8MMpfL1+DoC22MwFHeX75QEY2pmDj6r+MhOrpFGSdWWSY2zv1x0XhEbdkGKPHJccc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMtI4xHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMtI4xHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCECC4CEDD
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738862997;
	bh=MIDtZR1y3PjzaKr8zcfl8tq8955XS77PLHuHA9Uwmrw=;
	h=Date:From:To:Subject:From;
	b=PMtI4xHNMUbedrPPj15cDT0GFffjceh91hvO7w+ISqtZ1snsH1/osAgnZlhs/+LA6
	 TKrFOpHqENKHfP5IbHihfCzRSQfBNlgL8sGfwKKkonCclobstr20WGf6kymBM60UXv
	 hDWfiUxYSTlmr/PiapYYna0bTqr9Ht3uNmYg21LBAqhm8jNrIfsgEN+H4+Z586ppHV
	 oARh41prKHVgvKGZPsIQkOQSvaVEJVWj9Mu7o1+aloUmKaw/N4fTrb3xeObf/vIYc4
	 aw3Qh6Y6yTAIrPyNayv9YBvP2T9L0YowgOuKxEArCbacD4rD3U8HEuf1UZlyM92NrK
	 K1zSqMZQUGDSg==
Date: Thu, 6 Feb 2025 18:29:54 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs: for-next updated to eff7226942a5
Message-ID: <idd4ndguasosi677snbxkytfbnuqm2qw4nbbhzl6w3kagwv4ki@bgn4i3yxiukr>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

eff7226942a59fc78e8ecd7577657c30ed0cf9a8

3 new commits:

Darrick J. Wong (3):
      [a62ea4ad9cac] mkfs: fix file size setting when interpreting a protofile
      [a9d781ec5505] xfs_protofile: fix mode formatting error
      [eff7226942a5] xfs_protofile: fix device number encoding

Code Diffstat:

 mkfs/proto.c          | 5 +----
 mkfs/xfs_protofile.in | 4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

-- 
- Andrey
