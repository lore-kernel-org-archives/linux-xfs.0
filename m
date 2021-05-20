Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D31C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 08:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33901610A2
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 08:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhETI1K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 04:27:10 -0400
Received: from sonic313-48.consmr.mail.gq1.yahoo.com ([98.137.65.111]:44132
        "EHLO sonic313-48.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229536AbhETI1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 May 2021 04:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1621499148; bh=3pfMerXrnu6ygWCp1SNKk6dYr1Tue1pbsiZBuQkNAFE=; h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject:Reply-To; b=QwQqWOd4nUTX7eGmCuhEw0KE7DU1sLEm4zuCFuEj/zDfts8/WtM9fjRzbUN0DNMaXx8ngdfJY94sG8ImQogL1rnnyHcDfjP9JgoiLyv4k+kvcpXtNLmombMLV5nZlb+SPoC7nCGyQEhg4HZvI6ySgLgs3b54SdKOQYM0L0J3S7MU3Gv/HtxEkp9Q+A/ugO8eb2Omx7j6Lf6wGtbUifMmrgL3Uf1dXV8kGLyZH+Cp2s5r708imHeCRbjZde53xf0NtL3Cdbq81VYMUM4ozm4bjjA1T1r5qTFrJf8b1USDTlm5eblUL8yt5kI5ol1nxcA1B8vxj4b/eP6x8ZufHKZcvw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621499148; bh=4wUnM8FfAQPYcRXcCXYgkSCLCIP3KvwWKOZNwXEBzbZ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=i4UFjGDazLTc0rZY7aUR2ktqHWbPvvJ67dgryVRUhZd+5DjkKi+dVviZbz34S8FUmzXRp89YiyndkTYuDRoqKKGq6QUWey3F88Mw9okGZfjo5Iv0WszRb0pa7Yw+9Lw5kEyOytezKy04TVm6OvmhXinUcd06zBd84xPhN4K2OCZXHPWepM/E1BvtxSYY5FTiLxT+WVk/HVE9zOEOaJ/xPgrhikwJlgj7keYlQ4binPgzrcqSvB686yt0wchNOVLhVFFkarajliaJhouOisYmt7ec4InFEiAptGZM/fLzcm/850q98T14MdXcjVLjk3wGRnzf6pAphujCdS3yY/1Wag==
X-YMail-OSG: eXIORvgVM1kMOlQhzYVSgwrL57hF_SSgHB4OgtDr47JCTRgUuK7toniFK6aUD0b
 TbvIuJ8hcVgcwHU5k9E4rRYWBwbAtWISALZtEOJcNDnDqCcstXnGU42HBVIkBHH1ayv9inLv9emp
 AH3e2Hoby18GCpKuDCcn0FnDd5Myplwz6kf0FX3_cbujDk38A8V0KPoYvokxOgWWMGvfOBOCs1Kh
 emVWVxuARWaKfG6.mQsNlcsl07_m2GCU0URllXGphVcjXAkOYOUWNmsRnTuY1szNJjAO9tBJxGjb
 rQbVTXzjYubUH6eDA5XxKbXNfgfQOFYWfJAWBA0Dzoom.ShBvrNYw0rwCJ0.XqBReUHUwo4IoZmj
 O6r1AqMgo99gwDeO1YMTKv3XFA2WUqVlysCEL_zsgADU8dpY.pZjbXbhrVreXw3uTYhLC.MNHlfy
 jl1IODP90vMauCChNdNHiJGUhjPn545.TgFMIbpQGH1v7hpbodIVjWjsVAPJhu4LDtgxxQxHZqOM
 wMgc3EFrCBvP8zXt_eGa7tbjxew7Lr5vgqoN63b6kUvJwq.8I9pzjl0kSEhsEFFd5AZnveErpMUh
 ESK6puswQafasUkB.SJI4UwfyhwJuKcbQ2TuenAKHF5r7eAqtH3ju3YXIyLLlbNeJa4BHFWzTjVl
 a9.C0NwWmGVqAjRdAROVze8NieIxAtuVwZ8ST8x7WBHMHREr6em7gUvND.jCY2t9RWfqRaHjumNI
 h1yhpi_hP6tbBgm.ACBLCacxaf2J_7xQ38oLwF3Ze4APq.9TWFjNB9VuP7dumAFSQiSlEKkdm946
 85u1i0FYMHiPAQ4_o64jy4.4FyNsMp3sUMyDk50OR74mDYuxfTQOeVD8g8h4z6OD0ojb_X4tQMdH
 xGy_7ua1ULeY2kE616tCN1Ig5wrA_awC6LjOVbNnM9M1LEOZCBgv5_.08TtoKp3YVS7CzNuIvOv3
 7z58Ap4wQ4is2ArJ4qCJqEJ6NsVQUXkD6xFROrLn0jCmP8rkZGtkh6x.gJK40SWnubFrnbBs0e08
 jmvukIdoSFCX2nU2LTjuBTXTHNzQwWdsISJzIViAN8I15mhksdTKgVhwG2C90osMYqcy_tutfZiV
 XCG7QGIazzF9Iphk5nR_fLnuMDbU_PAvpajXDjrhbeGRn8PdYxGArxTiKo0iG590_klnQi3ubcCp
 r.jWKGvjaiyqIisbY.qEZ5eRVX37mcD369d.gO3Mz75o_tJrTqK6kcaFZ5cRYSZnDylfYLPvMZCx
 tRPDBYj98AGaZHSs73VvhR.7BXVO3RoYHnWKR2Zq6lrzPUt2kCtjPGWiTEFXPC7Pofq.Quw2Cg9W
 _iMYd1Rs86AHf335yuqefqkjFFPSmQQcjvc8ap6qgBdczFA9mVJM61UfHoqBhO0c3e7IfDYS6NyA
 JTPZS193C6s7FbkpfU6ZeyVjXG8c00mlToaTdV8Ny3AiWwLCoQa6RzXN6F1hZEuPi6CRix1JwZ_U
 LgCMSK2gyRgeSGNxSymcJShQUf41J7Nm9QqVyptGNkHmmIHYwvpTnmZ3TgTdKqTEgag7SYH8LNiE
 0nIuMy4kcIWE4L5DHeVmZ98KMHKMOnsbj_nvZ0Eo3OBX8DIOVYsYnDiMVy_4pqiJ4GTWrA7lZLwi
 wctpBc2p8vxpyJ4KKc6MiJpHIc16MW80HSIq.a17HcdbVcXeeOPrYtVYT7hPvyNrGrniv11wn5Na
 fZ_uVpTAuceHCP2O86eCBbO7JzqMzHfPt3FpzTe7JUMWdgYD9vKyY.pLurCaTvB1p8fPMb37q0WW
 DcUij4LQKmf3uf96Q5l7zVKY6mOf3f6AsqkZjhj7AiwI3O4SGN1zaL9Y3HK274ppIupZ2tryOI_A
 x6eWaBFuxgsItOy24v2VLppJc7uYhg19MeyQbKhheVi5jgYwtqHARpUuZCMo40psJbje0Ps8wysf
 vMNp9_9eYZRKJhLL7Y7.hlr1HasZBIUoYqW.aNnPO.dZtxAugNGvtBXQUF1_3E0fZ.Xbwc9tSzYM
 9aTy1rXrGzDcKLx4bHc_w3WTToMR8QkLqE_JJMiG8kXqZRfTIjmfbAqN6dquMspiH1jTY82q7eZu
 mGM1opKWw0gZwRBSNYTKiVbZgeo8kUWFHHyaZL_6GB.P_iplYllleKv4_qPRDQLE9FNQ1pAXWUfS
 TnKkilUNkYH4NgsFvRM5Mzpj2BzpUl7P6UJ5yaZDrWoE4_HzNf3QjIrIqhvswIpmsedEEsnSELUs
 2AdDG4IpWk.0M5OfFOMg.fMjone8BdWiA9rUb7YgENzUkLbCYV36ZQwxWMS7L36e2XaYCQuSFABj
 lsD2QGHBDChS4sS_xpNF.nU1hGKnT7GyZsgUS4qdNN2EmgMGvMAnXJYahwCvcgNXx.Yrd1viMKLt
 gvgstdZXoFX4uZy86N9HPQio6SsIY1Fc5nBn3kiPDZvfVZjwcFBnd7dj74P.uicsNTtuzCdbK7sl
 pNGZ7PK11Er2Ptrdpip3knm55hVQx_bBnSzl8sl_V5z4H2RKPG6UHCHhbbLogRYhyi32Wme4ueHz
 QMuhg
X-Sonic-MF: <hsiangkao@aol.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Thu, 20 May 2021 08:25:48 +0000
Received: by kubenode581.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID cfb3496798011237fe2492606428c016;
          Thu, 20 May 2021 08:23:47 +0000 (UTC)
Date:   Thu, 20 May 2021 16:23:22 +0800
From:   Gao Xiang <hsiangkao@aol.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: regressions in xfs/168?
Message-ID: <20210520082316.GA1782@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <20210519210205.GT9675@magnolia>
 <20210519222006.GA664593@dread.disaster.area>
 <20210520000802.GV9675@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210520000802.GV9675@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick and Dave,

On Wed, May 19, 2021 at 05:08:02PM -0700, Darrick J. Wong wrote:
> On Thu, May 20, 2021 at 08:20:06AM +1000, Dave Chinner wrote:
> > On Wed, May 19, 2021 at 02:02:05PM -0700, Darrick J. Wong wrote:
> > > Hm.  Does anyone /else/ see failures with the new test xfs/168 (the fs
> > > shrink tests) on a 1k blocksize?  It looks as though we shrink the AG so
> > > small that we trip the assert at the end of xfs_ag_resv_init that checks
> > > that the reservations for an AG don't exceed the free space in that AG,
> > > but tripping that doesn't return any error code, so xfs_ag_shrink_space
> > > commits the new fs size and presses on with even more shrinking until
> > > we've depleted AG 1 so thoroughly that the fs won't mount anymore.
> > 
> > Yup, now that I've got the latest fstests I see that failure, too.
> > 
> > [58972.431760] Call Trace:
> > [58972.432467]  xfs_ag_resv_init+0x1d3/0x240
> > [58972.433611]  xfs_ag_shrink_space+0x1bf/0x360
> > [58972.434801]  xfs_growfs_data+0x413/0x640
> > [58972.435894]  xfs_file_ioctl+0x32f/0xd30
> > [58972.439289]  __x64_sys_ioctl+0x8e/0xc0
> > [58972.440337]  do_syscall_64+0x3a/0x70
> > [58972.441347]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [58972.442741] RIP: 0033:0x7f7021755d87
> > 
> > > At a bare minimum we probably need to check the same thing the assert
> > > does and bail out of the shrink; or maybe we just need to create a
> > > function to adjust an AG's reservation to make that function less
> > > complicated.
> > 
> > So if I'm reading xfs_ag_shrink_space() correctly, it doesn't
> > check what the new reservation will be and so it's purely looking at
> > whether the physical range can be freed or not? And when freeing
> > that physical range results in less free space in the AG than the
> > reservation requires, we pop an assert failure rather than failing
> > the reservation and undoing the shrink like the code is supposed to
> > do?
> 
> Yes.  I've wondered for a while now if that assert in xfs_ag_resv_init
> should get turned into an ENOSPC return so that callers can decide what
> they want to do with it.

Thanks for the detailed analysis (sorry that I didn't check the 1k blocksize
case before), I'm now renting a department in a new city, no xfstests env
available for now.

But if I read/understand correctly, the following code might resolve the issue?

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 6c5f8d10589c..1f918afd5e91 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -312,10 +312,12 @@ xfs_ag_resv_init(
 	if (error)
 		return error;
 
-	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
-	       pag->pagf_freeblks + pag->pagf_flcount);
 #endif
+	if (xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
+	    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
+	    pag->pagf_freeblks + pag->pagf_flcount)
+		return -ENOSPC;
+
 out:
 	return error;
 }

If that works, could you kindly send out it (or some better/sane solution),
many thanks in advance!

Thanks,
Gao Xiang

> 
> --D
> 
> > IOWs, the problem is the ASSERT firing on debug kernels, not the
> > actual shrink code that does handle this reservation ENOSPC error
> > case properly? i.e. we've got something like an uncaught overflow
> > in xfs_ag_resv_init() that is tripping the assert? (e.g. used >
> > ask)
> > 
> > So I'm not sure that the problem is the shrink code here - it should
> > undo a reservation failure just fine, but the reservation code is
> > failing before we get there on a debug kernel...
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
