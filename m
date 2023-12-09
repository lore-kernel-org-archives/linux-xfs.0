Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F33VnNef"
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2847DBD;
	Fri,  8 Dec 2023 21:26:48 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6ce7c1b07e1so2217603b3a.2;
        Fri, 08 Dec 2023 21:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702099607; x=1702704407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EjHRg8iVC8GYPq9ZehmFNaJl2g2K4P4m59qHIzURNAo=;
        b=F33VnNefwPLmnzbpkok7uGg/MUjdEvXEyam5yR8OPxEiuqnDmbF64N9Uotun2gL1/u
         czjC2SjN7Tud9s2JMgTTKWwRZwxdTvjZHngfJwlK0XjxSXgedPexdmV3aMDntxfUJb/e
         gg+99Hzg/Ivix7j5ZIR4b15/KQuH8Jz0hz1jq57Svrs2TixxmsXT+7Qfhmbz3MXnU+UZ
         Yi1EifHK8oOLtV3easBKcMAjFbXCdpPZpZnBKDBWuejNCVReKO/+arXfcWa5orG3vLc3
         bmyatfwgv54OqRFPgmOYEucf9IaBaDvIsL9OnJvXBX+G+PWS6SqSO72cQsG7QjKT6hD2
         V9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702099607; x=1702704407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjHRg8iVC8GYPq9ZehmFNaJl2g2K4P4m59qHIzURNAo=;
        b=Ks0XnRpfq1M3OBRUBAAozGE3WtqkXZ0bBfb0pqcGtxwKogFS2ibSgcolI9KsTvzSt7
         St0mT98GL/Lu8aRzXgvAoWHOKblYo4Yqivxl4zRLGOtKrlGCVkjGPF2x8myP+AJ1ipfA
         lD2d5w1tqR7FOxLYeqFaLubkZLjVGifOuAmTeW9TGOa3NmxmUIwwKK8UM+CDm3AD1OOa
         MhLv9IowC/XNSW3OnocShDs7c9L4cQiJFXW/Aw73RpajU51oOJwE4ebmGV//3SxVjwD9
         SdNz+PJJ9x9iLVADwPZh9jn/TmgINIBSdAhuekdnU5I6910eEjDbhh5MRF/Fl30OeeMG
         mOtA==
X-Gm-Message-State: AOJu0Yy/X+74OSXM+cN28dmhZrTcA9RYNjDvn7P/Kv0JiEwykUDV9ntP
	CRlQ+NJzn090YY55QeaJlZU=
X-Google-Smtp-Source: AGHT+IGSLq8m3aB5OKQ/vxjPdWklWjMOtZUHGTWwcI1WtBR/Vl7n6lx6j7I+TQM6XDZ0jJ0J91fwbw==
X-Received: by 2002:a05:6a00:2e84:b0:6ce:2732:573 with SMTP id fd4-20020a056a002e8400b006ce27320573mr1371175pfb.36.1702099607545;
        Fri, 08 Dec 2023 21:26:47 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id z9-20020a6552c9000000b005c662e103a1sm2110558pgp.41.2023.12.08.21.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 21:26:47 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id C7B52117A5553; Sat,  9 Dec 2023 12:26:43 +0700 (WIB)
Date: Sat, 9 Dec 2023 12:26:43 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux XFS <linux-xfs@vger.kernel.org>,
	Linux Kernel Workflows <workflows@vger.kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Allison Henderson <allison.henderson@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Charles Han <hanchunchao@inspur.com>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH v3] Documentation: xfs: consolidate XFS docs into its own
 subdirectory
Message-ID: <ZXP6kzbfUcLbBtCi@archie.me>
References: <20231129123947.4706-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Kk62WifU3GBr5GRN"
Content-Disposition: inline
In-Reply-To: <20231129123947.4706-1-bagasdotme@gmail.com>


--Kk62WifU3GBr5GRN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 07:39:47PM +0700, Bagas Sanjaya wrote:
> XFS docs are currently in upper-level Documentation/filesystems.
> Although these are currently 4 docs, they are already outstanding as
> a group and can be moved to its own subdirectory.
>=20
> Consolidate them into Documentation/filesystems/xfs/.
>=20
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Hi Jon, Chandan, and Darrick,

FYI, XFS tree [1] is not updated since 2 weeks ago (and this patch doesn't =
get
picked up). Would you like to route this patch through docs-next tree or
xfs/for-next?

Thanks.

[1]: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/

--=20
An old man doll... just what I always wanted! - Clara

--Kk62WifU3GBr5GRN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZXP6jwAKCRD2uYlJVVFO
oxU1AP4jHVfyJmXI++jLGPE2Zks2FVbRtyizSnuZWYyjV8xrNAD+JvPtIU+1K2Z4
p5sDf0K0clWRHzntlLUAEDyZIChwiAA=
=CXvn
-----END PGP SIGNATURE-----

--Kk62WifU3GBr5GRN--
