Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8AB9C433B4
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 16:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1CDC611CB
	for <linux-xfs@archiver.kernel.org>; Sat,  1 May 2021 16:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhEAQ0l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 1 May 2021 12:26:41 -0400
Received: from sonic316-33.consmr.mail.gq1.yahoo.com ([98.137.69.57]:39390
        "EHLO sonic316-33.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQ0l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 May 2021 12:26:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1619886351; bh=r+Rxz3UE26IqK43Yk+ac8890+0xf5akAj0LPNoImWSI=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject:Reply-To; b=d8ZAX4IusQKXLqdRBcvOEQEYmo18QQi3oCDeTycFJ8BrOYGoTFF/6kwo3UJRG1GyeCYuD5V44cZcwvtWPfEvD3OuGyT+O3ORXIJ2Rh+hON8996r3CcLmOJWULRLDLMKYuDku05Qx2XzHdLph+EqwRcKCcGpYcp8axXdPRscZiIzCtu4xl6Mqbx2/H+rNzvkJx3L6ul8OBNjuo5Mx+qEacMiY7Nmni3NyDjIMTKH69mRpLF5ny5pgT4LwuO2QFcZ8daYzpmwZ0DUVdkxLudXAwJG+J5ifgo1KtxAK+uW3XyHOx14CgOwvZSCpQiY2RW/ByYwdaI/B344wGgA8vGWC2Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1619886351; bh=+6HPbWV7VnsyaQCFApwBXASWdeWuw7n8mK01J7/8xWb=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=EuM7Vq5CFq6gD1ARAeb/hv34Npf+A/kFRon90Scyj+i6HChbFGKDHKoowz2iuRmDkdsQGKbJ9NsMKLkvJZXPSjUwgn/7380ueZa5vd0LX/uvb4xAuGuIyTohEn6WkC43a3FwNEjugp9jEr542KLuhF0UTzaeHIN7Z+42O1Jm3nSPQPTUMzCeuI9Q20wK9Ked45iMmhiTq3LnK7x6wyvjw1zpE1ZmnHWE68VDfYTm2dh4zzvUWCbOc1+sLbTJwS2WxKeT2WpxLVEafg+KTgF6/OPGjNiSIn80+RSEfMDw9YvXrazo0B7JMG5X/7ClzPmvF0OXEylJ768tW3NLKZpkyw==
X-YMail-OSG: 5_r6pvQVM1mmoifhirUl7Gr92eZwui8oyQUQjW.6ZGEovyjaZTQbV3wTgp1hJqJ
 v8Ut21e5NCEs0Gmfs8T9egZIcyGR.DJ4qxd6ccfsChObXnqfVfujqs_P8YBtH5H5DFx4360zFDox
 L2QLWxojRoEq30Cw2_L4nUGulpJqsLCKYbWbGyh1xoJjkSWmSxePXR1FndOErPwibL_7N5eG04EC
 i4yZ7fGDhRgXsBnG37TyW.PsJDLlXqI1le2CjEmBWDSsPvNOR_TGGvtbxY2hzrnRAeEmSrVRup_x
 tsZBs5dxIKmCHAKILbzO8zmOazBGnaJgPIfpb3zuHuUVoE6YI2hXA_k.rxTxngE0EsP41uHHK34.
 SWemJeJelHCta2Ys7oi5Cc.186_y5_zlU1rUfYbyCXaGApYKKFsqNhk.kKOysJ3rnjcyEF1IGWVb
 RX6K9m8Pz6fV4O_Z.PdPBpI9cS1p3wURPN24P4a49XA9.tjSjcBxxMv0lfLfJZvBdPbd2P_HEJWt
 sE.q9lJ2xtcD26_iKclwr2nxIg0PxcBUVRVmZ.lNc86L6UZdakyJDVyNsPqkP67DPq9MdZW4EISp
 y09k_FN.YNvVelQ0AISk8s4d8OPP7yXv6AHWJ6uo_SclnlgqhVavcqShusIj3Qc2Fk_4dODiJK7G
 iRVvvDMvVQ4bwDUbwRUoMDCOnYj2nNsPwhLV0eyDtYCy1Gfqc_69wDJlhMyVTzS_2ODCRPIiK3O0
 QL63Sjx4Epf1rQdC7OPhC6eDoF5UpukvhNARlGpUT687lFoph5FmG4uXxaJeWJTSgznCj8KX0i92
 nqdeYitwN30.WTMP0LlzGX79osqeWsZHzcRcCdZJttRbCSEVzUl1I9HL8llcaKxtwNZFnnuZ5TYU
 A5Mtmea13YfHW.iVyjQRyCDj8PltOjsz7KqT4FlVsC.Hx_VuPtKY.YO2YunRvAGqfOBqVpEtjViH
 x902gB1YSfy1OHxke4aWGjpFDYND0R1yUuEBAz5WE2j4TLJGniJZD67maUON59ipiHNTjwbW8pxs
 I5gwcLVR1ZH0QuGByj49LNAaOfMqDhmkoe.iC0cL.258nxXMMw34vL0OpMGMFqKKKrs91CBUtMe1
 .H..2V36tvLVBbe3aYVS5y8.UWWxom.18fS0enFkCGc_hHzsMS6hhxFexT_sRtzLXa7WdPoSCAYq
 C9B3yRqYCLV4kKMJmhHNsPMPHw0TzTnTQ_0FuT63HRi0TsomtV_5YNIBCB8OJtnUgq1d3ycDOu_M
 Y0sBEda5xqKLsx2qUCJ8wwJamLhgv3ZnsRyNyTXdOA_UEpbjZTdXj3XokDaE90GZ2JjB4E.sJWYC
 EI0v7.Nd86_I7EIMNrsbYTQA0IX_0zi7pFZhc461rtXWnZnrKlhGESsTaA7iPb8L1nsnLq8fKaPN
 6iHZoTONlL6gQkCYDCI1pcfwgQui2IDuUQE7A2sgt4q746NglV03W6VLz13BhiHEpupShtXnmqA.
 4xM7v3Y3wZQbRwCivGtbtqHCgXxvOaJzYQmgZ8ye4xz4rjOLIdPNuo6WEbOUQ3.dXAEbX9BMX9Te
 6mG95.AsLhOVi06Vm5KV4zzXKEuBidJABfamoR_sSyK1yef7sR7ryWToygf6ICywQzmwhgPRRU2A
 peU7.PoXKmF44Aqsj9z0wOm5UnmnFUJXT6VfvgoJICvbwBLctLOWEbh8_ev1Tf070kQcP.YGUkEN
 fZkogy8pbZe42d6hCPiJDWsxcAvH1zO71oD3.reUFoyIQISCBZ5tO1pAN8_T.spUZFfZKcIA5Gyg
 C_smza7pYMg13Og5e_PGWuS755caRT0NtgUvabb_I9mySQ7ek1VaexXmSPMkiPtBE3_kkmSYfXjw
 zQMzpoqDY3aQsgcWzKlqvoTPNu4BDV0h4zByTE64cHOUJyhxIfC5ZU_F5mDbtZYnDIZTmNWtzHmt
 LBrT4D1.3mvrNjwmBUvhR5kvW9X0rjytqZMUo6S2ZWBU0QdKzPkTf9AoBDgzAq2y1GSvGAmzxoS5
 UFO7MQ8L17ceP3ksykb2BN8fDbrVVAZCYqzKstlAraPHgpJnAjxMt7Dw6cX0353o1LVtTmpqrisf
 u.2iY6Umkryko7UC.J0OfdOWQGYH4BzEMRUrJNuqyX3jfczmEjYS8kLTts_23c5oenEwbGSX5WWg
 ZE2_iCDjcoKSgfvuSJwBpc98KOtKT0oGpwNT3tgf.7GZArugxxFambg04D4F72E.dHxjQ3gpxXcs
 A6THWYxE8ogLF2Q4KzeT2alIO3B6U_VIytP0nDYc31MdatHnggjxAzJ69jOW2b0dmgWbgg5YiTYT
 vwax9SJVugKF0JbEdjjF.xsQl21hnka7m4Y_A9uii3zIpt9HU1z4LMivTGcn4xjvmNTziThI6kxC
 EVkymWj7Wi.5x8BLMHUyVZgHQwgVzFv6rYl4L3njuW8Kf3jIOjdpw_j4NDEKvS9IIcepsHpbIOwh
 RJGmJFQGjSyzB429aIKd7VNdap8D.KRAYCgiIT3Qr0ITZ222rVjG0S_3Gib1qz_MYSqZwVsMGg5y
 G
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Sat, 1 May 2021 16:25:51 +0000
Received: by kubenode518.mail-prod1.omega.ir2.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 98b111aac4b950c22df14c38f854903b;
          Sat, 01 May 2021 16:23:48 +0000 (UTC)
Date:   Sun, 2 May 2021 00:23:19 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to d4f74e162d23
Message-ID: <20210501162319.GA1804@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210429160243.GD547183@magnolia>
 <65965754.2791270.1619869406755.JavaMail.zimbra@karlsbakk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65965754.2791270.1619869406755.JavaMail.zimbra@karlsbakk.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.18231 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Sat, May 01, 2021 at 01:43:26PM +0200, Roy Sigurd Karlsbakk wrote:
> hm… xfs_ag_shrink_space
> 
> does this mean xfs shrinking is getting closer to reality?
> 

Currently it has supported shrinking empty space of the tail AG.
For shrinking the entire empty AGs, the main discussion is still how to
deactivate AGs gracefully.

Thanks,
Gao Xiang


> Vennlig hilsen
> 
> roy
> -- 
> Roy Sigurd Karlsbakk
> (+47) 98013356
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> Hið góða skaltu í stein höggva, hið illa í snjó rita.
> 
