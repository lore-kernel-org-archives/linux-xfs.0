Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925EE37C0F3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 05:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781674050; cv=none; b=N8ya/j0s1P3YPRoVg9IggDT6iwZP4/KZwA0y+KFJELqTLKrq5uMnJQUVKaAU1z2OweBxKh6xRN9d197CUX1vTrYDRYLIjQ+DA6omH55qi96pVvC3Uju/rs2AvV4jTOzCmA3/kJMO+OdgKaznKnD17JnDAWxJXqB3Q2rkS0zXkPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781674050; c=relaxed/simple;
	bh=1T3ZqAb1liPafRI7MAfOvGNlChL0cBsS3Wrl6VL2WFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sif/652xB+RK4Jv2pDaDBSlvQeL03Zaucq4I/WsEajyBknx70Pl/Ymq87ozR3xjhOKNPqyIf7STSxYoJuz0tH2d3H1aa1NK8vnNI3rr0sJpPduEbFjyt8nnwNhqjxuyi5l7kobxUNRu6eDrP4+k4/uKdtwKe4Cu4fmF6kF2ltaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=qED6DXfO; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="qED6DXfO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781673996;
	bh=YmgTO2BO0qxmCEzmuEuMPAqkdmHWZq+PyDJGBAKpJpg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=qED6DXfOChVfCVSzS7sK9qAwuwLeKiLvmmIFfDUcBrQIujzpXdWXdrKXtWhsLJm/R
	 U1pyzyYcdXZ8vpBzzMOegRImcRG66Q4wCZSNzYlD9o8Nc1oCiLMXPPZ7Zckhys0MVS
	 gamkAmB4ZpkVGrDHpSgmqzmhLE6o5hW5lvH0bXwc=
X-QQ-mid: zesmtpgz6t1781673980t8d436dac
X-QQ-Originating-IP: 4hruuGMFFSf0xXsduT+D5/DKjZ1FaTyLHzpcARUR5uw=
Received: from localhost.localdomain ( [1.85.7.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 17 Jun 2026 13:26:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9046515483551711118
EX-QQ-RecipientCnt: 4
From: caina <caina@uniontech.com>
To: hch@infradead.org
Cc: caina@uniontech.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up spelling and grammar errors in comments
Date: Wed, 17 Jun 2026 13:26:18 +0800
Message-Id: <20260617052618.3702-1-caina@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ajFK3-Z7CpIx4Wh8@infradead.org>
References: <ajFK3-Z7CpIx4Wh8@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: OQqGeHK5cVylVuSXcizprmeuSZEFaC+XD0TXWT1SeGnuAsFXlACEZgy1
	HjPZB7ShOxoyArVT3vmPumbzQEQ7oWlhO+UxzMhIzRg+8GqtqA5sJXPTKm25BIyosIVvB7C
	Z7GvS2h3HGGW4fizR9in0qwoDKD4o5Evvw1hmON7fORHKSzPRsJA772Xs138ybxXDmc+MfI
	XSwD9IELtE07yRpUZRD1Z3DsLevNBFUv4/Kiy0DsUB3B1b6SU4aJ5do/8PCrQpnF/1eMNli
	piZkb+vrwL2qCeYIihTqRbwSulUXbwFUVWINhBSiqcbQZ0uzN3f3AvkZhFzBpI3AKhkd82T
	c+aRsVzY/Nxb40Nx9njX2akxZ+klvkdPdPojLN8gvVtBF2QjtELbMLFu46Dtyorpp9V/h5e
	P8ixQLd8nWQ8U43S7pplT8dH7Vl8CglepQJRgaF2DxjQDlGf0YgYiJzQrD+DUBM0UoPSG1x
	zFGK4GY4WgVQneWksP+a6tuzlDXaga9B3UEg9LxnS3iixH7Z/IG5eu3bOCqRDn8uVnK6gaB
	U7EcCdZEZ6KtPxX+mgrb38aCxAv4BtRx3Y7ylKKX7PA0ngAjAliVPPq2522KGhz4hRuP0nN
	HQOeWC6pFKAH5xD4kGTAsLo3FZSGlHcpJM0MC+Mha0IMnL8hyuZBev7FHVdl+XpUcSnUTDV
	1lyEfYoVFdVWwibfsH9FwbcyAgBO0cplXub38Hc+WX0pC7wUsVJgHzGe5xQ/m1PY3haqNWp
	Kt0H2B/7+E5dump92hOZUHbDHXsXkD0YjvmU7TcdZuuuGM+TA/+8oDnwPPE97NE76WAOf7o
	3n7cFekCoC/etGmkIPc2gnek3v0leEOB1m25AOITqWDGP7zjodwFcKR7IbMYmH1tCmE7zQi
	4vrHBel5BSfbzOWgnoGmIVKHdkq4EQKWzVfTew82W2m/b4e5gb2BVX69AvpiGWoXRhHoJQ5
	YD9+jkJ1KBPVXAI6y9H542JOaMoPe4TH10Tz6CB5u1shmHxF5FkEKO9e/HkkIlnE8NKhcHk
	BNzIhRgYmpC3Xqbnur2cSI2PJubOvm9YXLHugJ39NSvTEN4RbcenpS9IbVji6tUYx4ZKuXI
	qxP2A6awxsC
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

On Tue, Jun 16, 2026 at 06:08:47AM -0700, Christoph Hellwig wrote:
> On Tue, Jun 16, 2026 at 10:09:12AM +0800, caina wrote:
> > -    * If we need to re-sort the free extents by length, do so so that we
> > +    * If we need to re-sort the free extents by length, do so that we
> >      * can put the records into the cntbt in the correct order.
> 
> This looks incorrect to me, but I'm not a native speaker.

Hi Christoph,

Thank you for the review.

I agree with you – the original "do so so that" is indeed correct here.
"do so" means "perform the re-sorting", and "so that" introduces the purpose.
Removing one "so" would make it ungrammatical. I will keep this line as "do so so that" in the next version.

> > @@ -342,7 +342,7 @@ xchk_btree_block_check_siblings(
> >     /*
> >      * Does the left & right sibling pointers match the adjacent
> >      * parent level pointers?
> 
> Should the does here be a do?

You are right – the subject "pointers" is plural, so the auxiliary verb should be "Do".
I will change it to "Do the left & right sibling pointers..." accordingly.

I will send a v2 patch with both fixes.

Please let me know if you have any other suggestions.

Thanks,
Caina
