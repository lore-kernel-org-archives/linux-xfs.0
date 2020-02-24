Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A65DC11D32
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D32721744
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 16:41:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=btinternet.com header.i=@btinternet.com header.b="pqZ+G8nm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgBXQlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:41:53 -0500
Received: from mailomta17-re.btinternet.com ([213.120.69.110]:35288 "EHLO
        re-prd-fep-048.btinternet.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727636AbgBXQlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 11:41:53 -0500
Received: from re-prd-rgout-004.btmx-prd.synchronoss.net ([10.2.54.7])
          by re-prd-fep-048.btinternet.com with ESMTP
          id <20200224164149.CGRI13347.re-prd-fep-048.btinternet.com@re-prd-rgout-004.btmx-prd.synchronoss.net>;
          Mon, 24 Feb 2020 16:41:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=btinternet.com; s=btmx201904; t=1582562509; 
        bh=xVLo85Z1ALUuuCKO6W76fU8v3DGJ8qX3lHRFe03ek7M=;
        h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:MIME-Version;
        b=pqZ+G8nmzQrB06KsosvEJY7vmU/huwMudTNEgfV0xJrcwfXG9uBtr+JUfcvQH67qzntbyYADPvAYJuld4CnDmUb0e6f1QziT4dmy841lXcczi5zpjPNbV8zRZfdIcCjx3k4eu/VDGrWEz2hSKnApmPZqfnQagG44nd6vAneSP01MYSen+HEm0DoY7ej68/+heYBwhlN5ytchYFDAToGP1DxRAwTjj4M+qLjPsJjbxxOyNHSQ7l20nOV6VEU2pA5WjxM7903+oRss5PHF5mQucI0lDIWHQbQdrElZVl9nPYexHC2m0Y/zOShNca0XHatb3kMOvI5/G0+CkszWsPyr4g==
Authentication-Results: btinternet.com;
    auth=pass (PLAIN) smtp.auth=richard_c_haines@btinternet.com
X-Originating-IP: [31.49.59.100]
X-OWM-Source-IP: 31.49.59.100 (GB)
X-OWM-Env-Sender: richard_c_haines@btinternet.com
X-VadeSecure-score: verdict=clean score=0/300, class=clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedugedrledtgdelfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemuceutffkvffkuffjvffgnffgvefqofdpqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkffuhffvffgjfhgtfgggsehmtderredtreejnecuhfhrohhmpeftihgthhgrrhguucfjrghinhgvshcuoehrihgthhgrrhgupggtpghhrghinhgvshessghtihhnthgvrhhnvghtrdgtohhmqeenucfkphepfedurdegledrheelrddutddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplhhotggrlhhhohhsthdrlhhotggrlhguohhmrghinhdpihhnvghtpeefuddrgeelrdehledruddttddpmhgrihhlfhhrohhmpeeorhhitghhrghruggptggphhgrihhnvghssegsthhinhhtvghrnhgvthdrtghomhequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoegurghrrhhitghkrdifohhnghesohhrrggtlhgvrdgtohhmqedprhgtphhtthhopeeohhgthhesihhnfhhrrgguvggrugdrohhrgheqpdhrtghpthhtohepoehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeophgruhhlsehprghulhdqmhhoohhrvgdrtghomheqpdhrtghpthhtohepoehrihgthhgrrhgupggtpghhrghinhgvsheshhhothhmrghilhdrtghomheqpdhrtghpthhtohepoehs
        ughssehthigthhhordhnshgrrdhgohhvqedprhgtphhtthhopeeoshgvlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrgheq
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from localhost.localdomain (31.49.59.100) by re-prd-rgout-004.btmx-prd.synchronoss.net (5.8.340) (authenticated as richard_c_haines@btinternet.com)
        id 5E3A181A03076442; Mon, 24 Feb 2020 16:41:49 +0000
Message-ID: <5c1f2125a44006d7ff8bda6d9a1075d2177aeaf0.camel@btinternet.com>
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
From:   Richard Haines <richard_c_haines@btinternet.com>
To:     Paul Moore <paul@paul-moore.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, selinux@vger.kernel.org
Date:   Mon, 24 Feb 2020 16:41:17 +0000
In-Reply-To: <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
         <20200220155731.GU9506@magnolia> <20200220155938.GA1306@infradead.org>
         <2862d0b2-e0a9-149d-16e5-22c3f5f82e9e@tycho.nsa.gov>
         <20200220160820.GA14640@infradead.org>
         <CAHC9VhRXo=EZ4HbLa_W_waL4xtdE6M92em7aNh=wm_7hpozJ7g@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-ryOXDiKEJiT4n91JJBtc"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--=-ryOXDiKEJiT4n91JJBtc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2020-02-22 at 14:49 -0500, Paul Moore wrote:
> On Thu, Feb 20, 2020 at 11:08 AM Christoph Hellwig <hch@infradead.org
> > wrote:
> > On Thu, Feb 20, 2020 at 11:06:10AM -0500, Stephen Smalley wrote:
> > > > The dquot_* routines are not generic quota code, but a specific
> > > > implementation used by most non-XFS file systems.  So if there
> > > > is a bug
> > > > it is that the security call is not in the generic dispatch
> > > > code.
> > > 
> > > Hmm...any reason the security hook call couldn't be taken to
> > > quota_quotaon()?
> > 
> > I haven't touched the quota code for a while, but yes, the existing
> > calls should move to the quota_* routines in
> > fs/quota/quota.c.  Note
> > that you still need to add checks, e.g. for Q_XSETQLIM.
> 
> Who wanted to submit a patch for this?  Christoph were you planning
> on
> fixing this?  If not, Richard, do you want to give it a try?
> 

I've had a go at this and found I can (almost) get it working. I've
attached a sample patch just in case anyone is interested.

However if the calls do need to move to fs/quota/quota.c, then I think
the xfs team are best placed to do this (I've had my playtime).



--=-ryOXDiKEJiT4n91JJBtc
Content-Disposition: attachment; filename="security-xfs-quota.diff"
Content-Type: text/x-patch; name="security-xfs-quota.diff"; charset="UTF-8"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNfcXVvdGFvcHMuYyBiL2ZzL3hmcy94ZnNfcXVvdGFvcHMu
YwppbmRleCAzODY2OWU4MjcuLmMwMmNmOWE2MyAxMDA2NDQKLS0tIGEvZnMveGZzL3hmc19xdW90
YW9wcy5jCisrKyBiL2ZzL3hmcy94ZnNfcXVvdGFvcHMuYwpAQCAtMTQsNyArMTQsNyBAQAogI2lu
Y2x1ZGUgInhmc190cmFucy5oIgogI2luY2x1ZGUgInhmc19pY2FjaGUuaCIKICNpbmNsdWRlICJ4
ZnNfcW0uaCIKLQorI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CiAKIHN0YXRpYyB2b2lkCiB4
ZnNfcW1fZmlsbF9zdGF0ZSgKQEAgLTE2MSwxMSArMTYxLDE1IEBAIHhmc19xdW90YV9lbmFibGUo
CiAJdW5zaWduZWQgaW50CQl1ZmxhZ3MpCiB7CiAJc3RydWN0IHhmc19tb3VudAkqbXAgPSBYRlNf
TShzYik7CisJc3RydWN0IGRlbnRyeQkJKmRlbnRyeSA9IG1wLT5tX3N1cGVyLT5zX3Jvb3Q7CiAK
IAlpZiAoc2JfcmRvbmx5KHNiKSkKIAkJcmV0dXJuIC1FUk9GUzsKIAlpZiAoIVhGU19JU19RVU9U
QV9SVU5OSU5HKG1wKSkKIAkJcmV0dXJuIC1FTk9TWVM7CisJLyogRW11bGF0ZXMgZHF1b3RfcXVv
dGFfb24oKSBMYWJlbGVkIGNvcnJlY3RseSAqLworCWlmICghc2VjdXJpdHlfcXVvdGFfb24oZGVu
dHJ5KSkKKwkJcmV0dXJuIC1FQUNDRVM7CiAKIAlyZXR1cm4geGZzX3FtX3NjYWxsX3F1b3Rhb24o
bXAsIHhmc19xdW90YV9mbGFncyh1ZmxhZ3MpKTsKIH0KZGlmZiAtLWdpdCBhL2ZzL3hmcy94ZnNf
c3VwZXIuYyBiL2ZzL3hmcy94ZnNfc3VwZXIuYwppbmRleCAyMDk0Mzg2YWYuLjU5ODU1ZDA2MCAx
MDA2NDQKLS0tIGEvZnMveGZzL3hmc19zdXBlci5jCisrKyBiL2ZzL3hmcy94ZnNfc3VwZXIuYwpA
QCAtMzksNiArMzksNyBAQAogI2luY2x1ZGUgPGxpbnV4L21hZ2ljLmg+CiAjaW5jbHVkZSA8bGlu
dXgvZnNfY29udGV4dC5oPgogI2luY2x1ZGUgPGxpbnV4L2ZzX3BhcnNlci5oPgorI2luY2x1ZGUg
PGxpbnV4L3NlY3VyaXR5Lmg+CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3VwZXJfb3BlcmF0aW9u
cyB4ZnNfc3VwZXJfb3BlcmF0aW9uczsKIApAQCAtMTUwNyw2ICsxNTA4LDIyIEBAIHhmc19mY19m
aWxsX3N1cGVyKAogCQlnb3RvIG91dF91bm1vdW50OwogCX0KIAorCS8qCisJICogRW11bGF0ZXMg
ZHF1b3RfcXVvdGFfb25fbW91bnQoKSBhbmQgd29ya3MsIGhvd2V2ZXIgdGhlIGRlbnRyeQorCSAq
IGlzIHVubGFiZWxlZDoKKwkgKiAgICBhbGxvdyB0ZXN0X2ZpbGVzeXN0ZW1fdCB1bmxhYmVsZWRf
dDpkaXIgeyBxdW90YW9uIH07CisJICovCisJc3RydWN0IHhmc19tb3VudAkqbXB4ID0gWEZTX00o
c2IpOworCXN0cnVjdCBkZW50cnkJCSpkZW50cnkgPSBtcHgtPm1fc3VwZXItPnNfcm9vdDsKKwlp
ZiAoWEZTX0lTX1FVT1RBX1JVTk5JTkcobXApKSB7CisJCWVycm9yID0gc2VjdXJpdHlfcXVvdGFf
b24oZGVudHJ5KTsKKwkJaWYgKGVycm9yKSB7CisJCQlkcHV0KHNiLT5zX3Jvb3QpOworCQkJc2It
PnNfcm9vdCA9IE5VTEw7CisJCQlnb3RvIG91dF91bm1vdW50OworCQl9CisJfQorCiAJcmV0dXJu
IDA7CiAKICBvdXRfZmlsZXN0cmVhbV91bm1vdW50OgpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkvc2Vj
dXJpdHkuYyBiL3NlY3VyaXR5L3NlY3VyaXR5LmMKaW5kZXggZGI3YjU3NGM5Li5hYzBjYzk4NzIg
MTAwNjQ0Ci0tLSBhL3NlY3VyaXR5L3NlY3VyaXR5LmMKKysrIGIvc2VjdXJpdHkvc2VjdXJpdHku
YwpAQCAtNzcwLDYgKzc3MCw3IEBAIGludCBzZWN1cml0eV9xdW90YV9vbihzdHJ1Y3QgZGVudHJ5
ICpkZW50cnkpCiB7CiAJcmV0dXJuIGNhbGxfaW50X2hvb2socXVvdGFfb24sIDAsIGRlbnRyeSk7
CiB9CitFWFBPUlRfU1lNQk9MKHNlY3VyaXR5X3F1b3RhX29uKTsKIAogaW50IHNlY3VyaXR5X3N5
c2xvZyhpbnQgdHlwZSkKIHsK


--=-ryOXDiKEJiT4n91JJBtc--

