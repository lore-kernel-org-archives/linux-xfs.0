Received: from mailsrv29.linznet.at (mailsrv29.linznet.at [80.66.43.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A524E1B3
	for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.66.43.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715536868; cv=none; b=MPET0iKPKomc3m84R5gChEdwRdArpV0iiO87+mqISElfXNSeKKL/mf4FCD9aLcw+3Np7RhRtAku8v5arGJ0Q8I6wrfC61VrE/p+1ATzjenFVEwJ7wmDZH2PybTSW+0OEyA+GV9h9X+S7QvYpUcl/pQ2L8Ch8dsqkGnymQtAngYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715536868; c=relaxed/simple;
	bh=UverqURZXDy6c4zKvWln00JkpijfVdClxADL1R9bW/g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r7GCqML9ykoWm/ksl+UVX6CLf/X8nYaZ9uMR5UQI6h59eSeoMmPYraZvY9dr6KICsWOAb9T2ulrr0LLiN1iCqhAQB2J9tT7MuyMS/EBpcfXFL3UhpPoIGt5TnaLPWHSDO0YnM0E67Pm0L8P4MTgWt0spBk3CbOSswEaGNxhWbUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linznet.at; spf=pass smtp.mailfrom=linznet.at; arc=none smtp.client-ip=80.66.43.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linznet.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linznet.at
Received: from mail.linznet.at (mail.linznet.at [80.66.39.75])
	by mailsrv29.linznet.at (Postfix) with ESMTPS id A1DC97D299
	for <linux-xfs@vger.kernel.org>; Sun, 12 May 2024 19:51:26 +0200 (CEST)
Received: (qmail 793249 invoked from network); 12 May 2024 17:51:26 -0000
Received: from unknown (HELO zeus.localnet) (a03096@linznet.at@91.142.26.35)
  by mail.linznet.at with ESMTPA; 12 May 2024 17:51:26 -0000
From: Alexander Puchmayr <alexander.puchmayr@linznet.at>
To: linux-xfs@vger.kernel.org
Subject: Re: how to restore a snapshot in XFS ?
Date: Sun, 12 May 2024 19:51:25 +0200
Message-ID: <5778721.DvuYhMxLoT@zeus>
In-Reply-To:
 <PR3PR04MB7340EFE53D742D347C9ACE58D6E12@PR3PR04MB7340.eurprd04.prod.outlook.com>
References:
 <PR3PR04MB7340EFE53D742D347C9ACE58D6E12@PR3PR04MB7340.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Sonntag, 12. Mai 2024, 14:30:12 CEST Bernd Lentes wrote:
> Hi,
>=20
> I just created a XFS Partition to store raw images of qemu domains on it.
> I create snapshots of these files with cp --reflink.
> Is that the correct way ?
>=20
> Now I want to go back to such a snapshot. How do I achieve this ?
> Just copy the snapshot over the original ?
>=20
I'm following this strategy for several years now, in in case I need to=20
restore from such a "backup", I use cp --reflink when copying the snapshot =
over=20
the original.=20
Without the --reflink you'd get a completely new copy of your snapshot, and=
=20
when producing new snapshots they will not have anything in common with you=
r=20
previous snapshots --> more disc space.=20

Alex



> Thanks.
>=20
> Bernd
>=20
>=20
> --
>=20
> Bernd Lentes
> SystemAdministrator
> Institute of Metabolism and Cell Death
> Helmholtz Zentrum M=C3=BCnchen
> Building 25 office 122
> Bernd.lentes@helmholtz-munich.de
> +49 89 3187 1241
>=20
> Helmholtz Zentrum M=C3=BCnchen =E2=80=93 Deutsches Forschungszentrum f=C3=
=BCr Gesundheit und
> Umwelt (GmbH)
 Ingolst=C3=A4dter Landstra=C3=9Fe 1, D-85764 Neuherberg,
> https://www.helmholtz-munich.de Gesch=C3=A4ftsf=C3=BChrung: Prof. Dr. med=
=2E Dr. h.c.
> Matthias H. Tsch=C3=B6p, Dr. Michael Frieser | Aufsichtsratsvorsitzende:
> MinDir=E2=80=99in Prof. Dr. Veronika von Messling Registergericht: Amtsge=
richt
> M=C3=BCnchen HRB 6466 | USt-IdNr. DE 129521671




