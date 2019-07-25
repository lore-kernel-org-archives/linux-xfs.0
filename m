Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:53619 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726283AbfGYRVt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Jul 2019 13:21:49 -0400
Received: from rabammel.molgen.mpg.de (rabammel.molgen.mpg.de [141.14.30.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E1A68201A3C10
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 19:21:44 +0200 (CEST)
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Unmountable XFS file system after runnig stress-ng
Message-ID: <b92674c4-488e-15ec-2052-eb69e4f80b7e@molgen.mpg.de>
Date: Thu, 25 Jul 2019 19:21:43 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060701010000030208080102"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060701010000030208080102
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear Linux folks,


With Linux 4.19.57 I ran `sudo ./stress-ng -a 10` [1], and it looks like =
the
file system got corrupted.

Rebooting and trying to mount it shows the errors below.

```
[94273.250116] hrtimer: interrupt took 2941668 ns
[448632.389303] scsi 0:2:1:0: Direct-Access     ATA      HUS722T2TALA600 =
 MU03 PQ: 0 ANSI: 6
[448632.407830] sd 0:2:1:0: Attached scsi generic sg3 type 0
[448632.416356] sd 0:2:1:0: [sdd] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[448632.431927] sd 0:2:1:0: [sdd] Write Protect is off
[448632.436823] sd 0:2:1:0: [sdd] Mode Sense: 9b 00 10 08
[448632.443394] sd 0:2:1:0: [sdd] Write cache: disabled, read cache: enab=
led, supports DPO and FUA
[448632.528883]  sdd: sdd1 sdd2 sdd3
[448632.646750] sd 0:2:1:0: [sdd] Attached SCSI disk
[448771.414262] XFS (sdd1): Mounting V5 Filesystem
[448771.551801] XFS (sdd1): Starting recovery (logdev: internal)
[448772.041683] XFS (sdd1): xfs_do_force_shutdown(0x8) called from line 3=
68 of file fs/xfs/xfs_trans.c.  Return address =3D 00000000e24e28d1
[448772.054016] XFS (sdd1): Corruption of in-memory data detected.  Shutt=
ing down filesystem
[448772.062233] XFS (sdd1): Please umount the filesystem and rectify the =
problem(s)
[448772.069685] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.077119] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.085420] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.092846] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.101150] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.108576] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.116879] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.124308] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.132611] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.140037] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.148342] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.155767] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.164070] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.171502] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.179798] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.187233] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.195530] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.202964] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.211266] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.218699] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.227001] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.234437] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.242730] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.250160] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.258470] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.265898] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.274205] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.282576] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.291651] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.299795] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.308805] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.316949] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.325959] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.334112] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.343126] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.351273] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.360286] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.368432] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.377458] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.385610] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.395360] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.403540] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.412571] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.420735] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.429771] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.437912] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.446918] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.455058] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.464076] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.472217] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.481231] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.489367] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.498383] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.506529] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.515546] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.523688] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.532707] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.540847] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.549857] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.558003] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.567015] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.575154] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.584170] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.592311] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.601327] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.609462] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.618472] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.626615] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.635631] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.643773] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.652784] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.660925] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.669943] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.678076] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.687093] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.695228] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.704236] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.712379] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.721393] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.729530] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.738546] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.746683] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.755700] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.763846] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.772859] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.780994] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.790001] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.798136] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.807151] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.815299] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.824313] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.832456] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.841469] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.849607] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.858624] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.866763] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.875775] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.883909] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.892916] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.901053] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.910062] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.918202] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.927213] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.935355] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.944371] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.952517] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.961535] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.969678] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.978692] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448772.986837] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448772.995852] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.003987] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.013003] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.021138] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.030157] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.038299] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.047314] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.055458] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.064468] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.072612] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.081627] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.089772] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.098787] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.106930] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.115934] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.124071] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.133088] XFS (sdd1): xfs_imap_to_bp: xfs_trans_read_buf() returned=
 error -5.
[448773.141234] XFS (sdd1): xlog_recover_clear_agi_bucket: failed to clea=
r agi 2. Continuing.
[448773.150249] XFS (sdd1): Ending recovery (logdev: internal)
[448773.156875] XFS (sdd1): Error -5 reserving per-AG metadata reserve po=
ol.
[448773.164404] XFS (sdd1): xfs_do_force_shutdown(0x8) called from line 5=
48 of file fs/xfs/xfs_fsops.c.  Return address =3D 00000000030066f7
```

Mounting did not work, but `xfs-report -L /dev/sdd1` fixed it.

I would put this issue to rest, and just wanted to document it
publicly. Please tell me if I should do anything else.


Kind regards,

Paul


[1]: https://kernel.ubuntu.com/~cking/stress-ng/


--------------ms060701010000030208080102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EFowggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWNMIIEdaADAgECAgwcOtRQhH7u81j4jncwDQYJKoZIhvcNAQELBQAwgZUx
CzAJBgNVBAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1
dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNV
BAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjAeFw0xNjExMDMxNTI0
NDhaFw0zMTAyMjIyMzU5NTlaMGoxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAP
BgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEVMBMG
A1UEAwwMTVBHIENBIC0gRzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnhx4
59Lh4WqgOs/Md04XxU2yFtfM15ZuJV0PZP7BmqSJKLLPyqmOrADfNdJ5PIGBto2JBhtRRBHd
G0GROOvTRHjzOga95WOTeura79T21FWwwAwa29OFnD3ZplQs6HgdwQrZWNi1WHNJxn/4mA19
rNEBUc5urSIpZPvZi5XmlF3v3JHOlx3KWV7mUteB4pwEEfGTg4npPAJbp2o7arxQdoIq+Pu2
OsvqhD7Rk4QeaX+EM1QS4lqd1otW4hE70h/ODPy1xffgbZiuotWQLC6nIwa65Qv6byqlIX0q
Zuu99Vsu+r3sWYsL5SBkgecNI7fMJ5tfHrjoxfrKl/ErTAt8GQIDAQABo4ICBTCCAgEwEgYD
VR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0gBCIwIDANBgsrBgEEAYGt
IYIsHjAPBg0rBgEEAYGtIYIsAQEEMB0GA1UdDgQWBBTEiKUH7rh7qgwTv9opdGNSG0lwFjAf
BgNVHSMEGDAWgBST49gyJtrV8UqlkUrg6kviogzP4TCBjwYDVR0fBIGHMIGEMECgPqA8hjpo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMECgPqA8hjpodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMIHdBggrBgEFBQcBAQSB0DCBzTAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEoGCCsGAQUFBzAChj5odHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABLpeD5FygzqOjj+
/lAOy20UQOGWlx0RMuPcI4nuyFT8SGmK9lD7QCg/HoaJlfU/r78ex+SEide326evlFAoJXIF
jVyzNltDhpMKrPIDuh2N12zyn1EtagqPL6hu4pVRzcBpl/F2HCvtmMx5K4WN1L1fmHWLcSap
dhXLvAZ9RG/B3rqyULLSNN8xHXYXpmtvG0VGJAndZ+lj+BH7uvd3nHWnXEHC2q7iQlDUqg0a
wIqWJgdLlx1Q8Dg/sodv0m+LN0kOzGvVDRCmowBdWGhhusD+duKV66pBl+qhC+4LipariWaM
qK5ppMQROATjYeNRvwI+nDcEXr2vDaKmdbxgDVwwggWvMIIEl6ADAgECAgweKlJIhfynPMVG
/KIwDQYJKoZIhvcNAQELBQAwajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8G
A1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYD
VQQDDAxNUEcgQ0EgLSBHMDIwHhcNMTcxMTE0MTEzNDE2WhcNMjAxMTEzMTEzNDE2WjCBizEL
MAkGA1UEBhMCREUxIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MTQwMgYDVQQL
DCtNYXgtUGxhbmNrLUluc3RpdHV0IGZ1ZXIgbW9sZWt1bGFyZSBHZW5ldGlrMQ4wDAYDVQQL
DAVNUElNRzEUMBIGA1UEAwwLUGF1bCBNZW56ZWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDIh/UR/AX/YQ48VWWDMLTYtXjYJyhRHMc81ZHMMoaoG66lWB9MtKRTnB5lovLZ
enTIUyPsCrMhTqV9CWzDf6v9gOTWVxHEYqrUwK5H1gx4XoK81nfV8oGV4EKuVmmikTXiztGz
peyDmOY8o/EFNWP7YuRkY/lPQJQBeBHYq9AYIgX4StuXu83nusq4MDydygVOeZC15ts0tv3/
6WmibmZd1OZRqxDOkoBbY3Djx6lERohs3IKS6RKiI7e90rCSy9rtidJBOvaQS9wvtOSKPx0a
+2pAgJEVzZFjOAfBcXydXtqXhcpOi2VCyl+7+LnnTz016JJLsCBuWEcB3kP9nJYNAgMBAAGj
ggIxMIICLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFHM0Mc3XjMLlhWpp4JufRELL4A/qMB8GA1UdIwQYMBaA
FMSIpQfuuHuqDBO/2il0Y1IbSXAWMCAGA1UdEQQZMBeBFXBtZW56ZWxAbW9sZ2VuLm1wZy5k
ZTB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1nMi1jYS9w
dWIvY3JsL2NhY3JsLmNybDA4oDagNIYyaHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzIt
Y2EvcHViL2NybC9jYWNybC5jcmwwgc0GCCsGAQUFBwEBBIHAMIG9MDMGCCsGAQUFBzABhido
dHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwQgYIKwYBBQUHMAKGNmh0
dHA6Ly9jZHAxLnBjYS5kZm4uZGUvbXBnLWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBC
BggrBgEFBQcwAoY2aHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzItY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MEAGA1UdIAQ5MDcwDwYNKwYBBAGBrSGCLAEBBDARBg8rBgEEAYGtIYIs
AQEEAwYwEQYPKwYBBAGBrSGCLAIBBAMGMA0GCSqGSIb3DQEBCwUAA4IBAQCQs6bUDROpFO2F
Qz2FMgrdb39VEo8P3DhmpqkaIMC5ZurGbbAL/tAR6lpe4af682nEOJ7VW86ilsIJgm1j0ueY
aOuL8jrN4X7IF/8KdZnnNnImW3QVni6TCcc+7+ggci9JHtt0IDCj5vPJBpP/dKXLCN4M+exl
GXYpfHgxh8gclJPY1rquhQrihCzHfKB01w9h9tWZDVMtSoy9EUJFhCXw7mYUsvBeJwZesN2B
fndPkrXx6XWDdU3S1LyKgHlLIFtarLFm2Hb5zAUR33h+26cN6ohcGqGEEzgIG8tXS8gztEaj
1s2RyzmKd4SXTkKR3GhkZNVWy+gM68J7jP6zzN+cMYIDmjCCA5YCAQEwejBqMQswCQYDVQQG
EwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4
LVBsYW5jay1HZXNlbGxzY2hhZnQxFTATBgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzF
RvyiMA0GCWCGSAFlAwQCAQUAoIIB8TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xOTA3MjUxNzIxNDRaMC8GCSqGSIb3DQEJBDEiBCBTk8i6jV7CXTT0RDHQ
/eO6l1mfyYPo3FbMiUSP0oXe4jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MGoxCzAJBgNVBAYTAkRF
MQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEVMBMGA1UEAwwMTVBHIENBIC0gRzAyAgweKlJIhfynPMVG/KIw
gYsGCyqGSIb3DQEJEAILMXygejBqMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREw
DwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTAT
BgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzFRvyiMA0GCSqGSIb3DQEBAQUABIIBAKh6
JOutBl67ziCVDl4jtQzCopCbqCiLoxOCRusdEYHLi4uxGqjDTpo1QlEgoLOoD8rxBf41iMxw
X2YIgS3EoN1uzJLVNoTSqULg5tDrsWNxIo4vkTUNag1eazcWEeMZDuwgaSUb76YTidIS+dX9
CLRzaFN7Pfu8tTPS/X1pVKZUuM9AzaBnQqZnWkSkdfNH2ipxAZ+sfn8ntXao8Qjpv7Cppz9I
kbV/K0KFdZZr2zYXGkjjXMANGeJrCT719EAPZxTlob8esE04npN8ted+LtJApKmDqwmmg/Ra
PR5k2eUq4f2Onw2N5Stx+daNi1WeinLaqGwY5Zdo+QkozVhccU0AAAAAAAA=
--------------ms060701010000030208080102--
