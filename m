Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53CD3806B2
	for <linux-xfs@vger.kernel.org>; Mon,  9 Feb 2026 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770653652; cv=none; b=M3CUhJOtoZuBhSv16dg61No/oRJ2HbmursmraHANLHVMFEXODo5/Tb2N4cZyiR5aPOU8Yi3tjcoPqk5Wy9LQjB+Cs9lY/E+Qy+DYE1sXPBMLzvjeCxdL/8cvzl/ONEokDFR+5NUD6IA80aVZxBx+fi158OZtQsPsshc7KbrSocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770653652; c=relaxed/simple;
	bh=rkegBEhuHpHJfuQHQLBSXShXsOBjoTPDINf1anJFsxA=;
	h=MIME-Version:Message-ID:From:To:Subject:Content-Type:Date; b=M4A5bYa3+NdWEAavgkYXwOVsNKjrCWORO84fj9oirJnjF6Fzq0Nmy9Y2vd1JXv5HBdW8QYEqPuUey2zZUXQTUK9qvldXM0iHEcknhkLPis2Zn0h3JDulF+TjWSjZuOjoTG3L7IiTrw0sgXgfRrMaCG5tvR63RPtje0tqbcRQ9do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=techlord8@web.de header.b=iYcQ2C61; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=techlord8@web.de header.b="iYcQ2C61"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1770653643; x=1771258443; i=techlord8@web.de;
	bh=cQwmpSrBbhclz9jujQwX/Tcf3XbEoA6ZHoC4SuK2eEE=;
	h=X-UI-Sender-Class:MIME-Version:Message-ID:From:To:Subject:
	 Content-Type:Date:cc:content-transfer-encoding:content-type:date:
	 from:message-id:mime-version:reply-to:subject:to;
	b=iYcQ2C61262Vn1b3F5e4dgAgT7vaggloXJy66ndLo7w0Y8XIFBrXDoh0abgbZab+
	 lpYI2VM1IB54oy669gNqMR2doyJNqG+eS7/uydIR5xQuhs/LpPjqlord9gHSnh81H
	 nPqVjSbS8QVh9OfOQ/VCTP3e4HkpNfYUrb9aEi7Iv2TKyZTN9M8DDv/1iuNvsjfkT
	 36SgB2K9rDnkTzvRuJfYpZGf4WTxnwEKSsCd2zG8Hy780loLgvG9Ilnh1fRZ8c6MZ
	 2GC/bEigK60Cfk4TvZJQ7sxxnXjeTgs0gCH2cXJiw8SG+XwpbkEAQVFIavA35Y5uY
	 LVphd1VUtQS7k6N1VQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [79.241.204.26] ([79.241.204.26]) by
 trinity-msg-rest-webde-webde-live-54b976884-rzcfw (via HTTP); Mon, 9 Feb
 2026 16:14:03 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <trinity-fb1b39de-006e-4acc-8ab4-22a203b12391-1770653643533@trinity-msg-rest-webde-webde-live-54b976884-dmz76>
From: techlord8@web.de
To: linux-xfs@vger.kernel.org
Subject: What prevents XFS from being grown offline (without being mounted)?
Content-Type: text/plain; charset=UTF-8
Importance: normal
Sensitivity: Normal
Date: Mon, 9 Feb 2026 16:14:03 +0000
X-Priority: 3
X-Provags-ID: V03:K1:3SXJekzOCEpOjZpds17NsxoJG0+h0dfG3w8yqYSYDj7yhy2rVnDfyeANLCfRKoUpINHdV
 vYVW1URFCV8ROfUft+ZWxyAwpXO8bCcloi+vpNtZmC0OqKqmJkNhZ6qS7RZQVpMdNeI1YlqFUrJQ
 l3Q9wZr96dx8+jyIza6r3hm9nzyLZd7euCu256GPpBzm6UeRV8w/ORLXQhnEnHSierGFJ242WsQM
 4OtcPLStNnJJQBs0QjkMMwTwJrYNe0vqeQfD0g7/gSEZbt9C37MUxuHPCqqirgdJkcA35xwnWZU4
 UrJna/lsv4wSKCp5on5frAoJM4C1qoSiarYnXdB4GTnaVtb3+lUjet+Z7Gg78dqgYMv9DOaNX4lq
 YPIbRIdQhwq
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UmSbO9TKhL4=;ECg9xsWWfAfwwZrF/Q//VNaLfXG
 7puuoZXUiG2KpGMJtXNVAijBNIvDWmY5dS5lThpbqCHTI42FmyeRZQ8q9vmkY+UK/dlhEoRf5
 1dBeaqRvbjSvBU+MJ0dkr5yyi2RyUn8pPMkeiUPY5IC3LzGoPPeDISsaBNPmFE6OyzaGnEa5Y
 4Fc2bX3niMc2wt2842D4tiyV8+8bcoomk2LslmbzYDGA3zIvvhcl5M4cTw7ND7jYO4HFmbVW+
 lhJulEgEa7MZf829Pj/RTECJwMrfsJTk7PPUIjQ8qErLCmynohL+1qA7Y4nO8POnWImLukagA
 gC1f/owHilkcpXk+/kp5M8+5VuSLZdm2UvW+CHn8DyQDQgv70Jy9TfWUJpwl4hpl+gN7O5eX0
 /vB547C+INMgVI+3xBjm1mYyLIcC44DsVCVmJB9DLe8vJnwZRtuRJHaDF5bSw9N7W7oQjobrY
 PwycQKwa54K2fAbgcLW6BSG+xjdTAuAaMo9mTgAhVpkwY+K5MHlx7FMO5y396CeaxjSgTN9HR
 4oec/p3Ex8pvuSohim+i5jbauv3VYm8GRQMaVm9Mel7/yuf+I3uIsxCt5HGWTt6rCnawl4BqG
 diF2bnLT+/gSg+EmvBUP4OoWgNFrVQ/LKJ7HzPQAYyAY6Z46nBH1Yg4yytf83we0Jk+1w0MSt
 tgRIHNRvyUJLDNZBFf8FhrmEuSQVG1QR8v6ERI1Bn9EsJSpjyTw550bYnxM+zl8vqjhAYLy+Z
 VcAdlQfZSe7gyC4pg5xTstcd+gKVdWG+yUZbHlhLeoBLlzUrVLFsLfLgjmLZ+VGA97IDQ/bcA
 /4wveMLRArGtt5DbYTIN8mdqlpI8BHf7nJKpgLikBn/gYIvapS51nVIq9QOcQotY2ZbqjjJD+
 MrOuWRqctX0MJNOOyjnf8GqKfmy3lFVYQdhaftyTJ0Q2LavhmTziuSgMcas+0nuacfs1Hm9r6
 y2pwGg92TR3HcM5+m4X+r4B/jjtSCoVquRqEUjTZdPap/ubcUzzc3ZyTgTM6uI2p6TZVX+1+n
 P2Uuxy5wL+RdmBBizvqFPAg1AulBw1lHlC5FdRGxeVdrp3tWaevQ+PAFSbxuC/aUytAHOdkMF
 0F9ULI2F4ywvEWveqL208OQT/HtqeoS0wuq1GdxtNEj0fhRyxfr5SyRdJ0RURqUa7by8iBwLF
 RbGvlaQFTt1Ep43auiy80nQvNAribGdM5+J1xIsfpTA5Pq7DlfTgpGbsaWYH98Fsr2UfNJdxb
 0epBHI33rBSY0plEJiwz4R7qAb1vDWggsR+CaofXOoDTifs5LIZJLJYduwn70Kozc7T0zfETT
 Oyi7vVGtRbqt3KCbuHD3S0lji4JzPcwvRDaGuX/Vx6hnqfe0TcVaCkLoDgOT1VAupfd8slKUS
 3USdiGRdJBcEe3c3dasfog+Nmi5I4O6Hv8t2UcoESar2TgRS41IBpYPWR9sDhyM41f3JCWWY9
 V9gt5954aBkVAy9XMavQ6c7HRVgifoTE7WjT2akAE/QefSgLhvxGeYD0RUYFTE5wL0GANFCSd
 ES8/B8I4TTfGialnV45A/jhQi9Sw/sZU3sOx54i/VpwcPHTNK5tz4omgfLhvGBy+oCeWdEzrV
 dx1tWhn0qIkSfaWRnxP09EzG4Za+ZMccMonUUy9cgNHH9I3xCKf8gRdWXrXTulRTmtzPfTIUK
 gXQFSchRP4vbC96As4P871my1iZOovzuRX7e5vUosUHopr8Bo2smv6WWiyblXvc9lL6WcN5+c
 F6/wInIEXuK6NxMKtD6ZN26mfO8dQ0JTw6fmRgzbt1exPsGNDs6502YVrRFFn60SYcbFCSSN5
 5XE7W7DPnoo36B78p96bRQTDD9moVjx1dW07AzkIi++dAIcxmbcOIMoccnBYsyeLBPfmoYGO1
 bzaubkSl4QaSRvxO9pqmwQrEZRXraaFPtLgvAMcuklEh4/jBgvD/ADtiV8otT79Gmw32pkbQc
 u2xSpQ+nEpED2+Fv11SxOGn5ZHhgwG2KhAG6EW3yHH3dEo449zZ7VKGMinbXsPWJTMWzQTG3Z
 OiuuQBRp+3Vilf5zjCGdXec39MOKuo1e/PG3m2issrLpJyYPx1ocEeQhj3w5l6lKGjKSANi+e
 TozYlfhehFa/ADmL10PSYNYDPFxXG60ZUJdVxdVPsxJ1lNOz3E1Uew2qzceBgvYehKpPR3cFt
 iIoUd3VoHgTpkIYIJus2hLvDpfjSelVYgkjQhB2Kk6fqg/ascHz6ENQaEsPM6Jtl+cBTbEScZ
 p6SWKh6XN4vo2DQaqQTlQILdOCv0KrhIXDFqMjyWoCD/U7B3NPwZsbpnt12SM+O2S62SMm8Ho
 tgUwREnCzxl3eNlLkq6r0UcbMz28hdO5XrRsjCVcd4tl/UwFX8igKRaNQ5XeNbCJH2yoxr6eQ
 n6Hlkxo5YsooryWKb73IT1IH9jzl+gi2mlG2fCdR9aF75q0IksMg4EbqIInMD2c5+DxMlRfiX
 2QQ4IR1HkgCOgZVg7GMVh2gbIPj5Ofeg6mJRDb3GzEPdMaRwA1pWlOCpYC0ow9uWQN0ULy27A
 r/3J5CZi1zwEOjJGMPXsvYhiCvDP/lKTOgHD3Y3mxOPwfvQUhsURKNg0cE625Zv/t+OcuhS4D
 xHDNIDy6DLqVl363M5wD2KiZpEPWLN92BdDiTjylY5FVc7VRVh2QC2IpDXOJkJbm1jw00QZjn
 lIbHOSPVEDQBlJqnRcB3bxJtLJHvHTmXdSxrcMI3bQhvqByG9Xe/0UFwG/mgh6664lg/aaMTE
 AaqEEi/u/eCgXFInuQqZmmTCaGGx9Wxqeiip13LTF8SCIsGCCC6qiX+AJvsYtLSbxaaBCeH0C
 Oj2l3h/yrgao+mfSfQqBTytTJHeds0ydkBDd+pNDnEJ3PisexHu00hJPP62rUDusmuSwkQDRi
 doL+sS2QYngGmIQmjK4YsLwYpsN3XvknLLhon+mDprT4Puh5EYIojCqxtmIUnjrmh2GIduMnE
 ntQ3tPbf7pm0y9XuUxez7q/lXalS5Firgkb3YgIpC/21n7O0naVS9kmdPgKAroy7wRbn7idLU
 SEvWa5KsMoGQuyL+lJRBAdbtbZir8yuMc9gIhhyvD6mNbQ4xYXrU8vH07MTS/mkj4RtU+CrJG
 JHttsnNeUZFYYCOfF6X8stU4WNGSoRsWB6SiGRdpp7MS4sHkLBV7e2Mbigl4yFQhWhVzkjzFa
 fGaJfvP5JS1uFdGr4Oe9SlKWA2OEXbyZ3Nibd3M/jE8rGpIrnmmT//t2ceaWn2NdRVDGFaC7D
 oLi1IVWfNdTdcRYUjR7PyiS0eC+6fOl+Vw9G+1sWK6RlgAHAwvYMvhsAN3atcel4RojsYbzAX
 qABsG3TP80UV8jOfASXLl4G/PMR4D4aSlzKe1L43NN470BDO4oKrN2jeWi9JlcdeFaW8Ts4su
 3R1YDVR1/NALoT4Ll/xgiEU0rQoOV073MGnfmEHuc9Q4EJbJFuT9SEkUApLqOAueHXBeGZeQE
 LhnY/OZLqrOUsJa+yg0yqkDNu4QggIgGparUx4k6gxtpPzjPmRg511wJSkUjikqkPqqMgVwUi
 3h+ilMjGULK81mIyvYIPx9xqZtRtqu/UDZQ9lQ1jnog94o5wyrT7kag8aqygrNJDltQgbQ6eP
 KzkV3N/3BCPhnQ66bl4kr86FTzKVys/k0zVVNYyiNom/ZF8STba0794m90H/tiZu6qlkzcwBn
 DEbhPHlTbZP/9fWRpbyW0Aal7TqDy9xDya0dbvK+Lib3w8JinUnDxdhADj1lQYUAizVbPv1IS
 GAezMMDD4Ic1uyzK1Cevuyvb2shFnevxI5tGSFZ9cWKUspkrUY22w9oavAbPmcmSOEeXT0pry
 8SfFkOQR1WM/tDxoYEHXMv3o5Z1leKlk0NmiGsJOU6VYtEWhQkSINjS9E0EO3KHP3bL6fM2Xx
 VKphg7AZHCNgqSgA/VFcZkixq40Opz88BB9q68/fSHhCvW7xVgkn2y70P8axyPY4VUefTc6YW
 XctLLoh/6nCeGiuBBcP5rYks20D7HMGESQQTpUz2ExXuiJokLd7O7W73nzNBMsdMfluHeRiGZ
 9EJ9JolD/S3rgCd4SbDPdtbDo2451VNDPByYaW/WbCyTeZV5Nck+uvv+l3tUaWcxMY+EZIDnP
 r5hLkTdMvZktO4s6iqpTQHgnnzJweVZR2hTXmEpLYqVhfMkU8JOgVFsPIqg/YwL8jm9jQjjKJ
 qXNJTiBry/ySNVH49BQK1ed5BOfxfvg1NlE5eYIiE5skTsvzGDfu2f9SGG1WtbvsSHL/Y0GTi
 DyGODMUcokJ7JazIr17Pu7wbEkAoPKAVGnlQaQiij6+ZWPoghwru0QjUjtjNhRxJgwOhX7Prl
 b3VXeFlsTxoXjrAHGxIZZ7SSEY7Krqed2BIlBTWUzU2n55N/4PaXAkm7QaFVxZqUk15FyejmH
 E0shNnSBEd5pvBTuFDFV2qb+MR7D1dygCQ8GsjUsMhEu/ETlTlGcOnFRBq7QK34bQvng41p+H
 mx1oMI9fXTGO2Om/cguj/bSFe91tCWjbI+MzElFP5be88zaU4/QbtBx0OW6IPxXabS+htIRa5
 /4GDZH3Nd75LAMK38On2PrkLcwzvHLpDGrwHlG78MHwV1b3Dfxihp+519u1JPaWfCwNnKBLdx
 /SHdHfbWTdHtunHO+Gmb7D1KaN2wO5ZUh0jxl34rp9OZrUP294yxJJR/V5Qf4RnPKeaJOevy5
 3SQCluo=

It seems this has never been asked before, at least I wasn't able to find anything about it on the wiki (xfs.org) and the mail archives, nor on web search.

While the wiki has a detailed article about what complicates shrinking support  ( https://xfs.org/index.php/Shrinking_Support ), I was hoping to find something like this about offline growing but couldn't.

From the manual: "The filesystem must be mounted to be grown".

Common sense tells me offline growing should be simpler given that there is no interference from data being read and written at the same time. So why can XFS not be grown offline?
