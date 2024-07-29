Received: from sonic319-23.consmr.mail.gq1.yahoo.com (sonic319-23.consmr.mail.gq1.yahoo.com [98.137.66.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803B139CEF
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jul 2024 18:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.66.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722276823; cv=none; b=nG0A2mkgDN07nto7R683tgGNYeUizxpAw7C1JO2qxLrlZ+Hh7JNg0IBhpsLB532DKohMnD9frK2SBYQrvypR/ZsJX6QgBiun4oYJZld07sctd5Tn8Ni4uDHrWv8RWP/lmewFTIOiNlhzEwGPuAIgbNKcOpJPeeEjUKHQ/cW1oEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722276823; c=relaxed/simple;
	bh=rtvggRtEKzsJdEuO+wclYSrK2HnYWH/R2LXAxeHPlII=;
	h=Date:From:To:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=CxztbmiZXUx1C7BBOdkWYMK9Y1Lb5+XsMirzzm+EJMjlHfuqPZCCSxJyj/K9FER6/6HQQSWO8KZtMeaaSNzsdih5UQqSadJo2UNwT9LdOnoDxHCj5hnmGgpGaaCTYIQg6zBDxhTh1dXgvoiH5sEPj8MII9zYeMN5J8HrhW+nR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ZYMy/fBh; arc=none smtp.client-ip=98.137.66.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ZYMy/fBh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1722276820; bh=rtvggRtEKzsJdEuO+wclYSrK2HnYWH/R2LXAxeHPlII=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=ZYMy/fBh5tUPqW3P92YxDERoc58YJOfKX3ffUUTz4XXpjsH1p44cIcIOQUr4fSBof3xIQluDOGHwjH5EY7mbq/G3kfnxia8gkewXuCh+VyFZUC6Ks8OHjBxlt6FQe+s8i5AtW2E+J0bLfViFhkm/u9I0ZzeKXIqNfoRKi4Vbb9+hORNXol2STloncC0eYx2o93uVq2HIfs9JTzorp5fRym3Ibvqpp4qEEDM8eYeHakwk0wnq7oHp8Mtc3IZ9Mk3r5JE2nhfOvUmYApYKA0fmg1o+zz75lCp3WB4EyxJMYwbSsZWKuuECGjp0GqDShMug5o8WS5QdCp0e+B9jtj4kRQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1722276820; bh=s99fIanmeq9ZqCjW38gkTBaMm5XkIZm9hdnoxby2ekd=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=qeTp49lUTxOzaQUed393Cu5uWcPzqTZmolFe93e2jciYu90wlIoMcSJj1fapsWHRYD/x85LWk8dKtsqODA2fZlQa/oj/EJwwDBPU8o1oxTtaPiSx8z1coM0C9TYMtWJu1IbUqDGnOkBs1VxB6wMhFECPYXJClH9mLme3aSGL+eFEvx8ku+5wr1dVekKPojuSCKvcVWYXX8TqmmcaKgI9duhX3Q3sXpR2iNSYCd17fRowJJGr2fpAznjEbflORw+SmO85h/0Oykze5GqBnd1Xs1YVPuIU7nThf3dTW1q+X801pA0zvFsAc6x3CTvy34X5XuJN5IUF/ddCr8BaAPZD2w==
X-YMail-OSG: 0l7FMroVM1lfRB25OkJsko0kGmNhWMVKFUdhhSd8VkDqYf.mX1CkOtLJFb8V2sf
 5RDvETGFLLbpWHSQbGlUitZYS3GqeHI.43FqZ.vSwZk4E2uRYKuh8kr0t.dTzgx.jOmA.VxsWoey
 cNk7mNCN3Eb3Av6.OWtWzBIEC4VX9Apxo5mDmy_A8cgSirWEnktmYtvc4cbt3r98Zqs6hBYt_SJI
 t7JZzsCsE4ke.y2IStI648itqTGhhQEgbxWLJtMjgWWrwcUOvfETO88TDwWYwqELdaakC5M5DADq
 1r5AN8Wl94lfSi8JNOkOvL2Kqaqkb48o3MRCCWbJZDflgGQD1JpPNClxBIefmexr0KNjWxLwBr7.
 V7VwZPmIQVpLyC4hdL65yBTVsNe6S0nlkSN0Aq9IATvoSWwxPupvKbemUfdGoRitP4TG493wqqaN
 Tk4H6MfSV9VjLbzsjdd6FJwXhnciMih4v59UZrbUaCrqt13iYGUo5wvugeuM_NU7.JgdiSs.p.FS
 tyLcAOaagxCmNccL.Jl7.lopJzdUIYHb36CpuXnIQ8BJitiTb3A.E86LgkmEZ0z_1n8fYsjvH77q
 vxRLorXPqfwcKDUoCkkVSGg.A.U9WhCz2G0vUIbK.aqqvdPQ5714huyUf32vTVXNHAhTLrcNP4Vr
 c88BLrFHS8TVW6x4NxmpE_RZL3XoLi8Y0nj19AJG_0.M.JzlZvWe514pRN9H6omvq0dFLnrGBFrN
 1gXJn1da5qWbnPHAG763fD6zHR1JMkGxTMSUt15uMUadjXITTKLIyRe8VMdX0ZGPj1nJT7OS.jGV
 5tMSqb2n8J63_DbgzYwUEZMAwWfLKw0UTC7DaQwv3Qu2Ix9AUFAFOjif1fLW3rKENe7dfMr3Ccln
 L4zJnDqN6Qu87ScH_GYuXJkSwNYS8TBf5Gk3e_aby8lktQIjSbRxYHVIRBMgzwCTjKZg9RySTs2e
 RKF64uOfxT1rT6mxmJ_TjbXRL63fdAoBfuPwrq7VORH4Qrzd5JuxNewl3Ksre_t_F4Ig9SLTEIZ5
 NHB.en7K7xbtaez4b3fUYIee65klNcCWnVEYzhUJW9XmNlyy2JqThitSphg5UyuN0YNgP6EBHgP7
 w0XpSp4a1GSKvPPJtFn4Il.9BPlsMyHUfbJJ6CFsfDjyai8Og53WJe5OAOUBwuj3NvVOydQAQa8D
 IanIDoXWB0.83rsS2lIDC._Ps9sVzTyyZtxgZD.eEfe3NzXli_byGNL_gL980.Zg_fz50gK043sg
 65rMVlJAfiNwEBHE9.7DUyWqIjXuxkS4Zaavf82tFm4yC0leQTXsV2WbyYw3ihHSoQN7AzojdtQr
 nAc2S1Mw76PBZ3jj9ZOc2sSvi7cUcN7dpes9hYELZ6WWUPklt1QLWiPQHjNiWIFgGJg_2gcQylQJ
 koaoAzGgAa5fevCtW01WhvSeOgSatirptI2yg3JTij.xebZ7ySqN0f6hGalv.ooSXtb81WUij3bU
 l2BoeIjdmPHDUwXigASdSiDZesqHC3ntV2WlB4j0J80QQTT7On9R8tTbdCojnViQZRyACbllEIlT
 jXmH0pRvg8u7YuOixzZJD1XjDepFM4p3qcKMgPGMIYJC6F.UXt83L7jxNbY8YBtPlp0tZ_aic0fx
 7P77KrQSh7xT0rhIiK94HtO6n7NjtWQSk_jVCiUz3yHFzFhQcf_rv1Q7WmHw4EV5s8XdDJmaM6A7
 jmiKzhAOPLZli.NMKcNyhOLXQhVLaMjJxkksrKUzKf6Kqm449EeTpg2nvuwVJS7y6jgFK2qHwWZR
 fkAQg5EFBT06huETe2AsXw52_B34WewBKrp8P4hvT2171y588iLK9rWUAVfaFrzrjlDL_YC_pT4t
 uDNB9QpFomJn_kEi1baVOxVtXRWMkkljFdvvw3aHnoVuBqwf9Yt9hNYSbzH4PQ9Ykn_mmw91pgfF
 0YXUaK0JYTL6WNz1rcxwXGx96qpJC09KmIJmHxi1TxY7f22aE.p3yyxAEV2jqFR2sQ9QxBnoJzEc
 fZZQQOPjjvCVrAzE7oma2bphRCqCoEdd_idDeviUG_AJgaF3mZaZQbpGbrRsFRyn4FmWTf8QjOy8
 S8ds1B5JSmsdBvpdh9QUACPCqo9zUij3BsRw.1zV19ZV37R1mQjmX8Ckb_KKE.K7van0kyNJT0QJ
 agSFeXkU22g0mHanYcNHzOaorUN.Wk5eiOyPeRUyHRx6lpaRnGpkIFEwHIbqS
X-Sonic-MF: <santiago_kraus@yahoo.com>
X-Sonic-ID: e59a3f5c-e744-4b2d-a56b-a2e2bd7afbc8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic319.consmr.mail.gq1.yahoo.com with HTTP; Mon, 29 Jul 2024 18:13:40 +0000
Date: Mon, 29 Jul 2024 18:13:37 +0000 (UTC)
From: Santiago Kraus <santiago_kraus@yahoo.com>
To: linux-xfs@vger.kernel.org
Message-ID: <599054026.994781.1722276817040@mail.yahoo.com>
Subject: : xfsprogs xfs_repair Version 6.8.0-2 versus Version 6.9.0-1 =>
 segmentation fault line number 666 cache.c - libxfs_bcache
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <599054026.994781.1722276817040.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.22544 YMailNodin




Hello team

Did get that far which surpises me a a little bit especially that it fails =
at line number 666 in cache.c :)
What makes the difference is whether I use -vv ( -vvv -vvvv ans so on ) whi=
ch causes the SEGV or a single -v which runs through without problems.


Could somebody else please reproduce this?

GOOD
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
gdb -ex=3Dr --args xfs_repair -v /dev/sda

GNU gdb (GDB) 15.1
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from xfs_repair...
Reading symbols from /usr/lib/debug/usr/bin/xfs_repair.debug...
Starting program: /usr/bin/xfs_repair -v /dev/sda5

This GDB supports auto-downloading debuginfo from the following URLs:
<https://debuginfod.archlinux.org>
Enable debuginfod for this session? (y or [n]) y
Debuginfod has been enabled.
To make this setting permanent, add 'set debuginfod enabled on' to .gdbinit=
.
Downloading separate debug info for system-supplied DSO at 0x7ffff7fc5000
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
Phase 1 - Superblock finden und =C3=BCberpr=C3=BCfen...
- Block-Zwischenspeichergr=C3=B6=C3=9Fe ist auf 734520 Eintr=C3=A4ge gesetz=
t
Phase 2 - ein internes Protokoll benutzen
- Null-Protokoll...
zero_log: head block 2 tail block 2
- freier Speicher und Inode-Karten des Dateisystems werden
gescannt...
[New Thread 0x7ffff7459680 (LWP 460815)]
[New Thread 0x7ffff6c58680 (LWP 460816)]
[New Thread 0x7ffff6457680 (LWP 460817)]
[New Thread 0x7ffff5c56680 (LWP 460818)]
[New Thread 0x7ffff5455680 (LWP 460819)]
[New Thread 0x7ffff4c54680 (LWP 460820)]
[New Thread 0x7ffff4453680 (LWP 460821)]
[New Thread 0x7ffff3c52680 (LWP 460822)]
[New Thread 0x7ffff3451680 (LWP 460823)]
[New Thread 0x7ffff2c50680 (LWP 460824)]
[New Thread 0x7ffff244f680 (LWP 460825)]
[New Thread 0x7ffff1c4e680 (LWP 460826)]
[New Thread 0x7ffff144d680 (LWP 460827)]
[New Thread 0x7ffff0c4c680 (LWP 460828)]
[New Thread 0x7ffff044b680 (LWP 460829)]
[New Thread 0x7fffefc4a680 (LWP 460830)]
[New Thread 0x7fffef449680 (LWP 460831)]
[New Thread 0x7fffeec48680 (LWP 460832)]
[New Thread 0x7fffee447680 (LWP 460833)]
[New Thread 0x7fffedc46680 (LWP 460834)]
[New Thread 0x7fffed445680 (LWP 460835)]
[New Thread 0x7fffecc44680 (LWP 460836)]
[New Thread 0x7fffec443680 (LWP 460837)]
[New Thread 0x7fffebc42680 (LWP 460838)]
[New Thread 0x7fffeb441680 (LWP 460839)]
[New Thread 0x7fffeac40680 (LWP 460840)]
[New Thread 0x7fffea43f680 (LWP 460841)]
[New Thread 0x7fffe9c3e680 (LWP 460842)]
[New Thread 0x7fffe943d680 (LWP 460843)]
[New Thread 0x7fffe8c3c680 (LWP 460844)]
[New Thread 0x7fffe843b680 (LWP 460845)]
[New Thread 0x7fffe7c3a680 (LWP 460846)]
[Thread 0x7fffec443680 (LWP 460837) exited]
[Thread 0x7fffecc44680 (LWP 460836) exited]
[Thread 0x7fffee447680 (LWP 460833) exited]
[Thread 0x7fffeec48680 (LWP 460832) exited]
[Thread 0x7fffea43f680 (LWP 460841) exited]
[Thread 0x7fffe7c3a680 (LWP 460846) exited]
[Thread 0x7fffe843b680 (LWP 460845) exited]
[Thread 0x7fffe9c3e680 (LWP 460842) exited]
[Thread 0x7fffeb441680 (LWP 460839) exited]
[Thread 0x7fffe943d680 (LWP 460843) exited]
[Thread 0x7fffeac40680 (LWP 460840) exited]
[Thread 0x7fffe8c3c680 (LWP 460844) exited]
[Thread 0x7fffebc42680 (LWP 460838) exited]
[Thread 0x7fffed445680 (LWP 460835) exited]
[Thread 0x7ffff044b680 (LWP 460829) exited]
[Thread 0x7ffff0c4c680 (LWP 460828) exited]
[Thread 0x7ffff144d680 (LWP 460827) exited]
[Thread 0x7ffff1c4e680 (LWP 460826) exited]
[Thread 0x7ffff244f680 (LWP 460825) exited]
[Thread 0x7ffff2c50680 (LWP 460824) exited]
[Thread 0x7ffff3451680 (LWP 460823) exited]
[Thread 0x7ffff3c52680 (LWP 460822) exited]
[Thread 0x7ffff4453680 (LWP 460821) exited]
[Thread 0x7ffff4c54680 (LWP 460820) exited]
[Thread 0x7ffff5455680 (LWP 460819) exited]
[Thread 0x7ffff5c56680 (LWP 460818) exited]
[Thread 0x7ffff6457680 (LWP 460817) exited]
[Thread 0x7ffff6c58680 (LWP 460816) exited]
[Thread 0x7fffedc46680 (LWP 460834) exited]
[Thread 0x7fffef449680 (LWP 460831) exited]
[Thread 0x7ffff7459680 (LWP 460815) exited]
[Thread 0x7fffefc4a680 (LWP 460830) exited]
- Wurzel-Inode-St=C3=BCck gefunden
Phase 3 - f=C3=BCr jedes AG...
- agi unverkn=C3=BCpfte Listen werden gescannt und bereinigt...
- bekannte Inodes werden behandelt und Inode-Entdeckung wird
durchgef=C3=BChrt...
[New Thread 0x7fffe7c3a680 (LWP 460847)]
[New Thread 0x7fffe843b680 (LWP 460848)]
[New Thread 0x7fffe8c3c680 (LWP 460849)]
[New Thread 0x7fffe943d680 (LWP 460850)]
[New Thread 0x7ffff7459680 (LWP 460851)]
- agno =3D 0
[Thread 0x7ffff7459680 (LWP 460851) exited]
[Thread 0x7fffe943d680 (LWP 460850) exited]
[Thread 0x7fffe843b680 (LWP 460848) exited]
[Thread 0x7fffe8c3c680 (LWP 460849) exited]
[New Thread 0x7ffff7459680 (LWP 460852)]
[Thread 0x7fffe7c3a680 (LWP 460847) exited]
[New Thread 0x7fffe943d680 (LWP 460853)]
[New Thread 0x7fffe7c3a680 (LWP 460854)]
[New Thread 0x7fffe8c3c680 (LWP 460855)]
[New Thread 0x7fffe843b680 (LWP 460856)]
- agno =3D 1
[Thread 0x7fffe8c3c680 (LWP 460855) exited]
[Thread 0x7fffe843b680 (LWP 460856) exited]
[Thread 0x7fffe7c3a680 (LWP 460854) exited]
[Thread 0x7fffe943d680 (LWP 460853) exited]
[New Thread 0x7fffe843b680 (LWP 460857)]
[New Thread 0x7fffe8c3c680 (LWP 460858)]
[Thread 0x7ffff7459680 (LWP 460852) exited]
[New Thread 0x7ffff7459680 (LWP 460859)]
[New Thread 0x7fffe7c3a680 (LWP 460860)]
[New Thread 0x7fffe943d680 (LWP 460861)]
- agno =3D 2
[Thread 0x7fffe943d680 (LWP 460861) exited]
[Thread 0x7fffe7c3a680 (LWP 460860) exited]
[Thread 0x7ffff7459680 (LWP 460859) exited]
[Thread 0x7fffe8c3c680 (LWP 460858) exited]
[New Thread 0x7fffe943d680 (LWP 460862)]
[Thread 0x7fffe843b680 (LWP 460857) exited]
[New Thread 0x7fffe843b680 (LWP 460863)]
[New Thread 0x7fffe7c3a680 (LWP 460864)]
[New Thread 0x7ffff7459680 (LWP 460865)]
[New Thread 0x7fffe8c3c680 (LWP 460866)]
- agno =3D 3
[Thread 0x7fffe8c3c680 (LWP 460866) exited]
- neu entdeckte Inodes werden behandelt...
[Thread 0x7ffff7459680 (LWP 460865) exited]
[Thread 0x7fffe7c3a680 (LWP 460864) exited]
[Thread 0x7fffe843b680 (LWP 460863) exited]
[Thread 0x7fffe943d680 (LWP 460862) exited]
[New Thread 0x7fffe943d680 (LWP 460867)]
[New Thread 0x7fffe8c3c680 (LWP 460868)]
[New Thread 0x7ffff7459680 (LWP 460869)]
[New Thread 0x7fffe7c3a680 (LWP 460870)]
[New Thread 0x7ffff6c58680 (LWP 460871)]
[New Thread 0x7ffff6457680 (LWP 460872)]
[New Thread 0x7ffff5c56680 (LWP 460873)]
[New Thread 0x7ffff5455680 (LWP 460874)]
[New Thread 0x7ffff4c54680 (LWP 460875)]
[New Thread 0x7ffff4453680 (LWP 460876)]
[New Thread 0x7ffff3c52680 (LWP 460877)]
[New Thread 0x7ffff3451680 (LWP 460878)]
[New Thread 0x7ffff2c50680 (LWP 460879)]
[New Thread 0x7ffff244f680 (LWP 460880)]
[New Thread 0x7ffff1c4e680 (LWP 460881)]
[New Thread 0x7ffff144d680 (LWP 460882)]
[New Thread 0x7ffff0c4c680 (LWP 460883)]
[New Thread 0x7ffff044b680 (LWP 460884)]
[New Thread 0x7fffefc4a680 (LWP 460885)]
[New Thread 0x7fffef449680 (LWP 460886)]
[New Thread 0x7fffeec48680 (LWP 460887)]
[New Thread 0x7fffee447680 (LWP 460888)]
[New Thread 0x7fffedc46680 (LWP 460889)]
[New Thread 0x7fffed445680 (LWP 460890)]
[New Thread 0x7fffecc44680 (LWP 460891)]
[New Thread 0x7fffec443680 (LWP 460892)]
[New Thread 0x7fffebc42680 (LWP 460893)]
[New Thread 0x7fffeb441680 (LWP 460894)]
[New Thread 0x7fffeac40680 (LWP 460895)]
[New Thread 0x7fffea43f680 (LWP 460896)]
[New Thread 0x7fffe9c3e680 (LWP 460897)]
[New Thread 0x7fffe843b680 (LWP 460898)]
[Thread 0x7fffea43f680 (LWP 460896) exited]
[Thread 0x7fffeac40680 (LWP 460895) exited]
[Thread 0x7fffebc42680 (LWP 460893) exited]
[Thread 0x7fffeec48680 (LWP 460887) exited]
[Thread 0x7fffe943d680 (LWP 460867) exited]
Phase 4 - auf doppelte Bl=C3=B6cke =C3=BCberpr=C3=BCfen...
- Liste mit doppeltem Ausma=C3=9F wird eingerichtet...
- es wird gepr=C3=BCft ob Inodes Blocks doppelt beanspruchen...
[Thread 0x7fffe843b680 (LWP 460898) exited]
[Thread 0x7fffe9c3e680 (LWP 460897) exited]
[Thread 0x7fffeb441680 (LWP 460894) exited]
[Thread 0x7fffec443680 (LWP 460892) exited]
[Thread 0x7fffecc44680 (LWP 460891) exited]
[Thread 0x7fffed445680 (LWP 460890) exited]
[Thread 0x7fffedc46680 (LWP 460889) exited]
[Thread 0x7fffee447680 (LWP 460888) exited]
[Thread 0x7fffef449680 (LWP 460886) exited]
[Thread 0x7fffefc4a680 (LWP 460885) exited]
[Thread 0x7ffff044b680 (LWP 460884) exited]
[Thread 0x7ffff0c4c680 (LWP 460883) exited]
[Thread 0x7ffff144d680 (LWP 460882) exited]
[Thread 0x7ffff1c4e680 (LWP 460881) exited]
[Thread 0x7ffff244f680 (LWP 460880) exited]
[Thread 0x7ffff2c50680 (LWP 460879) exited]
[Thread 0x7ffff3451680 (LWP 460878) exited]
[Thread 0x7ffff3c52680 (LWP 460877) exited]
[Thread 0x7ffff4453680 (LWP 460876) exited]
[Thread 0x7ffff4c54680 (LWP 460875) exited]
[Thread 0x7ffff5455680 (LWP 460874) exited]
[Thread 0x7ffff5c56680 (LWP 460873) exited]
[Thread 0x7ffff6457680 (LWP 460872) exited]
[Thread 0x7ffff6c58680 (LWP 460871) exited]
[Thread 0x7fffe7c3a680 (LWP 460870) exited]
[Thread 0x7ffff7459680 (LWP 460869) exited]
[Thread 0x7fffe8c3c680 (LWP 460868) exited]
[New Thread 0x7fffe843b680 (LWP 460899)]
[New Thread 0x7fffe9c3e680 (LWP 460901)]
[New Thread 0x7fffea43f680 (LWP 460902)]
[New Thread 0x7fffeac40680 (LWP 460903)]
[New Thread 0x7ffff7459680 (LWP 460904)]
[New Thread 0x7ffff6c58680 (LWP 460905)]
- agno =3D 0
- agno =3D 2
- agno =3D 3
[Thread 0x7ffff7459680 (LWP 460904) exited]
- agno =3D 1
[Thread 0x7fffeac40680 (LWP 460903) exited]
[Thread 0x7ffff6c58680 (LWP 460905) exited]
[Thread 0x7fffea43f680 (LWP 460902) exited]
[Thread 0x7fffe9c3e680 (LWP 460901) exited]
[Thread 0x7fffe843b680 (LWP 460899) exited]
[New Thread 0x7ffff6c58680 (LWP 460906)]
[New Thread 0x7ffff7459680 (LWP 460907)]
[New Thread 0x7fffeac40680 (LWP 460908)]
[New Thread 0x7fffea43f680 (LWP 460909)]
[New Thread 0x7ffff6457680 (LWP 460910)]
[New Thread 0x7ffff5c56680 (LWP 460911)]
[Thread 0x7ffff5c56680 (LWP 460911) exited]
[Thread 0x7ffff6457680 (LWP 460910) exited]
[Thread 0x7fffea43f680 (LWP 460909) exited]
[Thread 0x7fffeac40680 (LWP 460908) exited]
[Thread 0x7ffff7459680 (LWP 460907) exited]
[Thread 0x7ffff6c58680 (LWP 460906) exited]
[New Thread 0x7ffff5c56680 (LWP 460912)]
[New Thread 0x7ffff6457680 (LWP 460913)]
[New Thread 0x7fffea43f680 (LWP 460914)]
[New Thread 0x7fffeac40680 (LWP 460915)]
[New Thread 0x7ffff7459680 (LWP 460916)]
[New Thread 0x7ffff6c58680 (LWP 460917)]
[Thread 0x7ffff5c56680 (LWP 460912) exited]
[Thread 0x7ffff7459680 (LWP 460916) exited]
[Thread 0x7fffea43f680 (LWP 460914) exited]
[Thread 0x7ffff6457680 (LWP 460913) exited]
[Thread 0x7ffff6c58680 (LWP 460917) exited]
[Thread 0x7fffeac40680 (LWP 460915) exited]
[New Thread 0x7ffff6c58680 (LWP 460918)]
[New Thread 0x7ffff7459680 (LWP 460919)]
[New Thread 0x7fffeac40680 (LWP 460920)]
[New Thread 0x7fffea43f680 (LWP 460921)]
[New Thread 0x7ffff6457680 (LWP 460922)]
[New Thread 0x7ffff5c56680 (LWP 460923)]
[Thread 0x7ffff5c56680 (LWP 460923) exited]
[Thread 0x7ffff6457680 (LWP 460922) exited]
[Thread 0x7fffeac40680 (LWP 460920) exited]
[Thread 0x7ffff7459680 (LWP 460919) exited]
[Thread 0x7ffff6c58680 (LWP 460918) exited]
[Thread 0x7fffea43f680 (LWP 460921) exited]
Phase 5 - AG-K=C3=B6pfe und B=C3=A4ume werden erneut gebildet...
- agno =3D 0
- agno =3D 1
- agno =3D 2
- agno =3D 3
- Superblock wird zur=C3=BCckgesetzt...
Phase 6 - Inode-Verbindbarkeit wird gepr=C3=BCft...
- Inhalte der Echtzeit-Bitmaps und Zusammenfassungs-Inodes werden zur=C3=BC=
ckgesetzt
- Dateisystem wird durchquert ...
[New Thread 0x7ffff5c56680 (LWP 460924)]
[New Thread 0x7ffff6457680 (LWP 460925)]
[New Thread 0x7fffea43f680 (LWP 460926)]
[New Thread 0x7fffeac40680 (LWP 460927)]
[New Thread 0x7ffff7459680 (LWP 460928)]
- agno =3D 0
[Thread 0x7ffff7459680 (LWP 460928) exited]
[Thread 0x7fffeac40680 (LWP 460927) exited]
[Thread 0x7fffea43f680 (LWP 460926) exited]
[Thread 0x7ffff6457680 (LWP 460925) exited]
[New Thread 0x7ffff7459680 (LWP 460929)]
[Thread 0x7ffff5c56680 (LWP 460924) exited]
[New Thread 0x7fffeac40680 (LWP 460930)]
[New Thread 0x7ffff5c56680 (LWP 460931)]
[New Thread 0x7fffea43f680 (LWP 460932)]
[New Thread 0x7ffff6457680 (LWP 460933)]
- agno =3D 1
[Thread 0x7ffff6457680 (LWP 460933) exited]
[Thread 0x7fffea43f680 (LWP 460932) exited]
[Thread 0x7ffff5c56680 (LWP 460931) exited]
[Thread 0x7fffeac40680 (LWP 460930) exited]
[New Thread 0x7ffff6457680 (LWP 460934)]
[Thread 0x7ffff7459680 (LWP 460929) exited]
[New Thread 0x7fffea43f680 (LWP 460935)]
[New Thread 0x7ffff7459680 (LWP 460936)]
[New Thread 0x7ffff5c56680 (LWP 460937)]
[New Thread 0x7fffeac40680 (LWP 460938)]
- agno =3D 2
[Thread 0x7fffeac40680 (LWP 460938) exited]
[Thread 0x7ffff5c56680 (LWP 460937) exited]
[Thread 0x7ffff7459680 (LWP 460936) exited]
[Thread 0x7fffea43f680 (LWP 460935) exited]
[New Thread 0x7fffeac40680 (LWP 460939)]
[Thread 0x7ffff6457680 (LWP 460934) exited]
[New Thread 0x7ffff5c56680 (LWP 460940)]
[New Thread 0x7ffff6457680 (LWP 460941)]
[New Thread 0x7ffff7459680 (LWP 460942)]
[New Thread 0x7fffea43f680 (LWP 460943)]
- agno =3D 3
[Thread 0x7fffea43f680 (LWP 460943) exited]
[Thread 0x7ffff7459680 (LWP 460942) exited]
[Thread 0x7ffff6457680 (LWP 460941) exited]
[Thread 0x7ffff5c56680 (LWP 460940) exited]
[Thread 0x7fffeac40680 (LWP 460939) exited]
- durchqueren beendet ...
- nicht verbundene Inodes werden nach lost+found verschoben ...
Phase 7 - Verweisanzahl wird gepr=C3=BCft und berichtigt...
[New Thread 0x7fffeac40680 (LWP 460944)]
[New Thread 0x7fffea43f680 (LWP 460945)]
[New Thread 0x7ffff7459680 (LWP 460946)]
[New Thread 0x7ffff6457680 (LWP 460947)]
[New Thread 0x7ffff6c58680 (LWP 460948)]
[New Thread 0x7ffff5c56680 (LWP 460949)]
[New Thread 0x7ffff5455680 (LWP 460950)]
[New Thread 0x7ffff4c54680 (LWP 460951)]
[New Thread 0x7ffff4453680 (LWP 460952)]
[New Thread 0x7ffff3c52680 (LWP 460953)]
[New Thread 0x7ffff3451680 (LWP 460954)]
[New Thread 0x7ffff2c50680 (LWP 460955)]
[New Thread 0x7ffff244f680 (LWP 460956)]
[New Thread 0x7ffff1c4e680 (LWP 460957)]
[New Thread 0x7ffff144d680 (LWP 460958)]
[New Thread 0x7ffff0c4c680 (LWP 460959)]
[New Thread 0x7ffff044b680 (LWP 460960)]
[New Thread 0x7fffefc4a680 (LWP 460961)]
[New Thread 0x7fffef449680 (LWP 460962)]
[New Thread 0x7fffeec48680 (LWP 460963)]
[New Thread 0x7fffee447680 (LWP 460964)]
[New Thread 0x7fffedc46680 (LWP 460965)]
[New Thread 0x7fffed445680 (LWP 460966)]
[New Thread 0x7fffecc44680 (LWP 460967)]
[New Thread 0x7fffec443680 (LWP 460968)]
[New Thread 0x7fffebc42680 (LWP 460969)]
[New Thread 0x7fffeb441680 (LWP 460970)]
[New Thread 0x7fffe9c3e680 (LWP 460971)]
[New Thread 0x7fffe943d680 (LWP 460972)]
[New Thread 0x7fffe8c3c680 (LWP 460973)]
[New Thread 0x7fffe843b680 (LWP 460974)]
[New Thread 0x7fffe7c3a680 (LWP 460975)]
[Thread 0x7ffff0c4c680 (LWP 460959) exited]
[Thread 0x7fffed445680 (LWP 460966) exited]
[Thread 0x7fffe943d680 (LWP 460972) exited]
[Thread 0x7fffe843b680 (LWP 460974) exited]
[Thread 0x7fffe8c3c680 (LWP 460973) exited]
[Thread 0x7fffe7c3a680 (LWP 460975) exited]
[Thread 0x7fffe9c3e680 (LWP 460971) exited]
[Thread 0x7fffeb441680 (LWP 460970) exited]
[Thread 0x7fffebc42680 (LWP 460969) exited]
[Thread 0x7fffec443680 (LWP 460968) exited]
[Thread 0x7fffecc44680 (LWP 460967) exited]
[Thread 0x7fffedc46680 (LWP 460965) exited]
[Thread 0x7fffee447680 (LWP 460964) exited]
[Thread 0x7fffeec48680 (LWP 460963) exited]
[Thread 0x7fffef449680 (LWP 460962) exited]
[Thread 0x7fffefc4a680 (LWP 460961) exited]
[Thread 0x7ffff044b680 (LWP 460960) exited]
[Thread 0x7ffff144d680 (LWP 460958) exited]
[Thread 0x7ffff1c4e680 (LWP 460957) exited]
[Thread 0x7ffff244f680 (LWP 460956) exited]
[Thread 0x7ffff2c50680 (LWP 460955) exited]
[Thread 0x7ffff3451680 (LWP 460954) exited]
[Thread 0x7ffff3c52680 (LWP 460953) exited]
[Thread 0x7ffff4453680 (LWP 460952) exited]
[Thread 0x7ffff4c54680 (LWP 460951) exited]
[Thread 0x7ffff5455680 (LWP 460950) exited]
[Thread 0x7ffff5c56680 (LWP 460949) exited]
[Thread 0x7ffff6c58680 (LWP 460948) exited]
[Thread 0x7ffff6457680 (LWP 460947) exited]
[Thread 0x7ffff7459680 (LWP 460946) exited]
[Thread 0x7fffea43f680 (LWP 460945) exited]
[Thread 0x7fffeac40680 (LWP 460944) exited]
[New Thread 0x7fffe7c3a680 (LWP 460976)]

XFS_REPAIR Zusammenfassung Mon Jul 29 19:28:31 2024

Phase Start Ende Dauer
Phase 1: 07/29 19:28:31 07/29 19:28:31
Phase 2: 07/29 19:28:31 07/29 19:28:31
Phase 3: 07/29 19:28:31 07/29 19:28:31
Phase 4: 07/29 19:28:31 07/29 19:28:31
Phase 5: 07/29 19:28:31 07/29 19:28:31
Phase 6: 07/29 19:28:31 07/29 19:28:31
Phase 7: 07/29 19:28:31 07/29 19:28:31

Gesamte Laufzeit:
erledigt
[Thread 0x7ffff7d32980 (LWP 460806) exited]
[Thread 0x7fffe7c3a680 (LWP 460976) exited]
[New process 460806]
[Inferior 1 (process 460806) exited normally]
(gdb) q

<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

NOT good

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>
gdb -ex=3Dr --args xfs_repair -vv /dev/sda5=20
GNU gdb (GDB) 15.1
Copyright (C) 2024 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from xfs_repair...
Reading symbols from /usr/lib/debug/usr/bin/xfs_repair.debug...
Starting program: /usr/bin/xfs_repair -vv /dev/sda5

This GDB supports auto-downloading debuginfo from the following URLs:
<https://debuginfod.archlinux.org>
Enable debuginfod for this session? (y or [n]) y
Debuginfod has been enabled.
To make this setting permanent, add 'set debuginfod enabled on' to .gdbinit=
.
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".

Program received signal SIGSEGV, Segmentation fault.
cache_report (fp=3D0x7ffff7f264e0 <_IO_2_1_stderr_>, name=3Dname@entry=3D0x=
55555560a253 "libxfs_bcache", cache=3D0x1ea834c7402a800) at cache.c:666
666 if ((cache->c_hits + cache->c_misses) =3D=3D 0)
(gdb) q
A debugging session is active.

Inferior 1 [process 459767] will be killed.

<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D



Cheers
Santiago Kraus

