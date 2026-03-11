Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C8347BB5;
	Wed, 11 Mar 2026 08:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773216505; cv=none; b=rOYKNnz/O9J/+FmlIrepip1G3ZG/fnPtU/A7K/BoktYbCAlAO+IP3dkKoIiwU/Q2qgifTVyvkzSUxUh5VA+sDhLgYEJXfAfZ7+l+KT87EqSfAG4ycgd77zyL/d6XjT/GQ+sTt6R9q5DlNo3OMU9aQjPJDrWkwZ+YXk5ofDrCeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773216505; c=relaxed/simple;
	bh=F1yKz2cNKfFmT4+PWmlovRfCcxtuvekcqi1QNT2OqbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AqtAZMo+Ot7/2Ivv+MscsQfYBcn8ezv1OeTtrELX2v0Dq90gk3RNW644dvizq6BSqDOpqNEBANL1DlZFRPqcn+NcX1FXo/IBOBieyMMlC5C9j0ftuLAQR46bkNv25WnI0tfYJCXQYcsSJ2A26XPeZ+9xpn4g8obJt5YUI5jamkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost (unknown [124.16.138.129])
	by APP-05 (Coremail) with SMTP id zQCowAD3hAjxIrFpyrEkCg--.57727S2;
	Wed, 11 Mar 2026 16:08:17 +0800 (CST)
From: Chen Ni <nichen@iscas.ac.cn>
To: cem@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Convert comma to semicolon
Date: Wed, 11 Mar 2026 16:08:17 +0800
Message-Id: <20260311080817.2906233-1-nichen@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <aa_Z9AkLoS6BrTwc@nidhogg.toxiclabs.cc>
References: <aa_Z9AkLoS6BrTwc@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAD3hAjxIrFpyrEkCg--.57727S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7k0a2IF6F4UM7kC6x804xWl14x267AK
	xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
	A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj
	6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gc
	CE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxI
	r21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87
	Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Av
	z4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxV
	AFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxU4U73DUUUU
X-CM-SenderInfo: xqlfxv3q6l2u1dvotugofq/

On Tue, Mar 10, 2026 at 09:52:15AM +0100, Carlos Maiolino wrote:
> What tree HEAD did you apply this on?
> 
> I can't find where this code exists. I'm assuming you sent it against
> some tree other than XFS's tree?

Hi Carlos,

You are correct. This patch was based on linux-next commit 7407c0fbfa90,
which is not present in the current XFS tree.

Please disregard.

Best regards,
Chen Ni

