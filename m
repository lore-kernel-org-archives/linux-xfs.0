Received: from mail.launchiq.pl (mail.launchiq.pl [57.129.61.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2898129B0
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.129.61.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753776988; cv=none; b=G/54SXIlMZ42a1tiA8wQCrr6kw+PIHnHbNDPFVSxcYgHpF6FMwRmRLHJTIGq45+TT14+VhsoCrU9nZaKIzTgTJi6Ytqr+7+pTXOIXwSZF6aSUiJGJjPjqgfguWPMBATn5Tj81wE4EgGhYPErbgit3CuoB0665p/J9aOLUmPpk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753776988; c=relaxed/simple;
	bh=1nV56yiRn7w88ZKIfi9xMzQzsEglWEb9KKVoIWzOJTA=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=WNG5lle+eT3/S9tj/bSx5BDT5HqVkpPbM5F5asNfpSTQeJAbi2Jx5KVD52eBxWalWvDsQtFYEKHVvZjXbWGag/K0oYmvsa4czbQW68XRteNrJDfZ5MwhMt3QJnWW4qoy3YLIvp5fw2q9YNcnbGugHKSnwKzIoFXNbWhKEbWEe1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=launchiq.pl; spf=pass smtp.mailfrom=launchiq.pl; dkim=pass (2048-bit key) header.d=launchiq.pl header.i=@launchiq.pl header.b=T4h1h983; arc=none smtp.client-ip=57.129.61.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=launchiq.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchiq.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchiq.pl header.i=@launchiq.pl header.b="T4h1h983"
Received: by mail.launchiq.pl (Postfix, from userid 1002)
	id 5866024660; Tue, 29 Jul 2025 08:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=launchiq.pl; s=mail;
	t=1753776984; bh=1nV56yiRn7w88ZKIfi9xMzQzsEglWEb9KKVoIWzOJTA=;
	h=Date:From:To:Subject:From;
	b=T4h1h983jjRSHE27CTyd1j/kxj+xDzqHQZsNuB9qe5pbmZEuRlOFtMjUouKOgh9ru
	 hSHKtVWRP9LE+bogQXkKUXDdMNWAsLqYKGb5xXnGBCq2pKj2v9WivE2Q9x7zyoWzMi
	 YOmRArH8o41srbodLSn4vyVL1O+ZfPpyJCd7hll1kdth27V7l7cOAtGpBDSRPfUQJj
	 gVmwxRBi6dyrw32IXls/jHfcjJhw+U3XTUQkg1REOz4wpeX+4m0hmdxw1WcYQA0TI1
	 DanfjMXYzlUeu1LAbp9f4BCd9mkt2JoxOuEomtW8ETl7ynE95WeVhHnMs8xynQhWTi
	 FeI29FjTK1jOA==
Received: by mail.launchiq.pl for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 08:16:19 GMT
Message-ID: <20250729064500-0.1.3m.azcu.0.sidt0jvm1f@launchiq.pl>
Date: Tue, 29 Jul 2025 08:16:19 GMT
From: "Grzegorz Sutor" <grzegorz.sutor@launchiq.pl>
To: <linux-xfs@vger.kernel.org>
Subject: Umowa vPPA - termin spotkania
X-Mailer: mail.launchiq.pl
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

mamy rozwi=C4=85zanie, kt=C3=B3re pozwala zabezpieczy=C4=87 korzystn=C4=85=
 cen=C4=99 energii na d=C5=82ugie lata =E2=80=94 bez konieczno=C5=9Bci zm=
iany obecnego dostawcy i bez inwestycji w instalacje odnawialne.

Proponujemy wsp=C3=B3=C5=82prac=C4=99 w oparciu o wirtualne umowy PPA (vP=
PA) =E2=80=93 to rozliczany finansowo kontrakt oparty na cenach SPOT, kt=C3=
=B3ry:

=E2=80=A2 stabilizuje koszty energii na 3 do 7 lat,
=E2=80=A2 wspiera realizacj=C4=99 polityki ESG i obni=C5=BCa =C5=9Blad w=C4=
=99glowy,
=E2=80=A2 zapewnia elastyczno=C5=9B=C4=87 zakupow=C4=85 =E2=80=93 cz=C4=99=
=C5=9B=C4=87 energii w sta=C5=82ej cenie z OZE, reszta  =20
  rozliczana na bie=C5=BC=C4=85co,
=E2=80=A2 nie wymaga zmian technicznych ani formalnych po stronie Pa=C5=84=
stwa firmy.

Wsp=C3=B3=C5=82pracujemy z przedsi=C4=99biorstwami zu=C5=BCywaj=C4=85cymi=
 od 3 do 30 GWh rocznie =E2=80=93 g=C5=82=C3=B3wnie z bran=C5=BC takich j=
ak przemys=C5=82, logistyka, handel, automotive, IT i data center.

Ch=C4=99tnie przygotujemy bezp=C5=82atn=C4=85 wycen=C4=99 i indywidualn=C4=
=85 propozycj=C4=99 kontraktu, dostosowan=C4=85 do profilu zu=C5=BCycia e=
nergii w Pa=C5=84stwa firmie.

Je=C5=9Bli temat jest dla Pa=C5=84stwa interesuj=C4=85cy, z przyjemno=C5=9B=
ci=C4=85 przeka=C5=BC=C4=99 wi=C4=99cej informacji lub um=C3=B3wi=C4=99 s=
potkanie z naszym specjalist=C4=85.


Z wyrazami szacunku.
Grzegorz Sutor
