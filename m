Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 04:34:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m32BXZNs000916
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 04:33:36 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56684729D05
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 04:34:11 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id JvviJI7HL8OTV0Cs for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 04:34:11 -0700 (PDT)
Date: Wed, 2 Apr 2008 13:30:03 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Serious XFS crash
Message-ID: <20080402133003.4bb043e4@galadriel.home>
In-Reply-To: <20080402055831.GG103491721@sgi.com>
References: <20080325185453.3a1957dd@galadriel.home>
	<20080325233611.GW103491721@sgi.com>
	<20080401140035.46470306@galadriel.home>
	<20080402055831.GG103491721@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_N0nVzd=sq85jQ=VAox5cYeJ"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

--MP_N0nVzd=sq85jQ=VAox5cYeJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le Wed, 2 Apr 2008 15:58:31 +1000 vous =E9criviez:

> The log is rather garbled - can you repost? Also, XFS usually outputs
> an error message before the stack trace; can you make sure you
> paste that as well (if it exists)?

Well I attached the relevant part of kern.log; the message just before
the crash is not very clear... You can see the other messages relevant
to the disk error too.

--=20
--------------------------------------------------
Emmanuel Florac               www.intellique.com=20=20=20
--------------------------------------------------

--MP_N0nVzd=sq85jQ=VAox5cYeJ
Content-Type: text/plain; name=log
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=log

TWFyICA2IDA2OjI1OjA0IHN5c3RlbTMga2VybmVsOiAzdy05eHh4OiBzY3Np
MDogQUVOOiBXQVJOSU5HICgweDA0OjB4MDAyMyk6IFNlY3RvciByZXBhaXIg
Y29tcGxldGVkOnBvcnQ9NiwgTEJBPTB4RTZFMkEuDQpNYXIgIDYgMDY6MjU6
MDQgc3lzdGVtMyBrZXJuZWw6IFJlaXNlckZTOiB3YXJuaW5nOiBpc190cmVl
X25vZGU6IG5vZGUgbGV2ZWwgMjg3ODQgZG9lcyBub3QgbWF0Y2ggdG8gdGhl
IGV4cGVjdGVkIG9uZSAxDQpNYXIgIDYgMDY6MjU6MDQgc3lzdGVtMyBrZXJu
ZWw6IFJlaXNlckZTOiBzZGExOiB3YXJuaW5nOiB2cy01MTUwOiBzZWFyY2hf
Ynlfa2V5OiBpbnZhbGlkIGZvcm1hdCBmb3VuZCBpbiBibG9jayA3NTM2NzEu
IEZzY2s/DQpNYXIgIDYgMDY6MjU6MDQgc3lzdGVtMyBrZXJuZWw6IFJlaXNl
ckZTOiBzZGExOiB3YXJuaW5nOiB2cy0xMzA3MDogcmVpc2VyZnNfcmVhZF9s
b2NrZWRfaW5vZGU6IGkvbyBmYWlsdXJlIG9jY3VycmVkIHRyeWluZyB0byBm
aW5kIHN0YXQgZGF0YSBvZiBbMTg0MDQgMTg0NjMgMHgwIFNEXQ0KTWFyICA2
IDEwOjQyOjQ2IHN5c3RlbTMga2VybmVsOiAweDA6IDAwIDAwIDAwIDAwIDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIA0KTWFyICA2IDEw
OjQyOjQ2IHN5c3RlbTMga2VybmVsOiBGaWxlc3lzdGVtICJtZDAiOiBYRlMg
aW50ZXJuYWwgZXJyb3IgeGZzX2FsbG9jX3JlYWRfYWdmIGF0IGxpbmUgMjE5
MCBvZiBmaWxlIGZzL3hmcy94ZnNfYWxsb2MuYy4gIENhbGxlciAweGMwMWY0
Yjg4DQpNYXIgIDYgMTA6NDI6NDYgc3lzdGVtMyBrZXJuZWw6ICBbeGZzX2Fs
bG9jX3JlYWRfYWdmKzI0NC80MzJdIHhmc19hbGxvY19yZWFkX2FnZisweGY0
LzB4MWIwDQpNYXIgIDYgMTA6NDI6NDYgc3lzdGVtMyBrZXJuZWw6ICBbeGZz
X2FsbG9jX2ZpeF9mcmVlbGlzdCsxMDAwLzExMjBdIHhmc19hbGxvY19maXhf
ZnJlZWxpc3QrMHgzZTgvMHg0NjANCk1hciAgNiAxMDo0Mjo0NiBzeXN0ZW0z
IGxhc3QgbWVzc2FnZSByZXBlYXRlZCAyIHRpbWVzDQpNYXIgIDYgMTA6NDI6
NDYgc3lzdGVtMyBrZXJuZWw6ICBbX3hmc190cmFuc19jb21taXQrNDg5Lzky
OF0gX3hmc190cmFuc19jb21taXQrMHgxZTkvMHgzYTANCk1hciAgNiAxMDo0
Mjo0NiBzeXN0ZW0zIGtlcm5lbDogIFt4ZnNfZnJlZV9leHRlbnQrMTUyLzIy
NF0geGZzX2ZyZWVfZXh0ZW50KzB4OTgvMHhlMA0KTWFyICA2IDEwOjQyOjQ2
IHN5c3RlbTMga2VybmVsOiAgW3hmc19ibWFwX2ZpbmlzaCsyNjMvNDAwXSB4
ZnNfYm1hcF9maW5pc2grMHgxMDcvMHgxOTANCk1hciAgNiAxMDo0Mjo0NiBz
eXN0ZW0zIGtlcm5lbDogIFt4ZnNfaXRydW5jYXRlX2ZpbmlzaCs1NDQvOTc2
XSB4ZnNfaXRydW5jYXRlX2ZpbmlzaCsweDIyMC8weDNkMA0KTWFyICA2IDEw
OjQyOjQ2IHN5c3RlbTMga2VybmVsOiAgW3hmc190cmFuc19pam9pbis0My8x
MjhdIHhmc190cmFuc19pam9pbisweDJiLzB4ODANCk1hciAgNiAxMDo0Mjo0
NiBzeXN0ZW0zIGtlcm5lbDogIFt4ZnNfaW5hY3RpdmUrMTE5NS8xMjk2XSB4
ZnNfaW5hY3RpdmUrMHg0YWIvMHg1MTANCk1hciAgNiAxMDo0Mjo0NiBzeXN0
ZW0zIGtlcm5lbDogIFt4ZnNfZnNfY2xlYXJfaW5vZGUrMTU2LzE5Ml0geGZz
X2ZzX2NsZWFyX2lub2RlKzB4OWMvMHhjMA0KTWFyICA2IDEwOjQyOjQ2IHN5
c3RlbTMga2VybmVsOiAgW2ludmFsaWRhdGVfaW5vZGVfYnVmZmVycysyMS8x
MTJdIGludmFsaWRhdGVfaW5vZGVfYnVmZmVycysweDE1LzB4NzANCk1hciAg
NiAxMDo0Mjo0NiBzeXN0ZW0zIGtlcm5lbDogIFtjbGVhcl9pbm9kZSsyMTIv
MzIwXSBjbGVhcl9pbm9kZSsweGQ0LzB4MTQwDQpNYXIgIDYgMTA6NDI6NDYg
c3lzdGVtMyBrZXJuZWw6ICBbdHJ1bmNhdGVfaW5vZGVfcGFnZXMrMjMvMzJd
IHRydW5jYXRlX2lub2RlX3BhZ2VzKzB4MTcvMHgyMA0KTWFyICA2IDEwOjQy
OjQ2IHN5c3RlbTMga2VybmVsOiAgW2dlbmVyaWNfZGVsZXRlX2lub2RlKzI2
NC8yNzJdIGdlbmVyaWNfZGVsZXRlX2lub2RlKzB4MTA4LzB4MTEwDQpNYXIg
IDYgMTA6NDI6NDYgc3lzdGVtMyBrZXJuZWw6ICBbaXB1dCs4My8xMTJdIGlw
dXQrMHg1My8weDcwDQpNYXIgIDYgMTA6NDI6NDYgc3lzdGVtMyBrZXJuZWw6
ICBbZG9fdW5saW5rYXQrMTg2LzI3Ml0gZG9fdW5saW5rYXQrMHhiYS8weDEx
MA0KTWFyICA2IDEwOjQyOjQ2IHN5c3RlbTMga2VybmVsOiAgW3N5c19mY250
bDY0Kzg5LzE0NF0gc3lzX2ZjbnRsNjQrMHg1OS8weDkwDQpNYXIgIDYgMTA6
NDI6NDYgc3lzdGVtMyBrZXJuZWw6ICBbc3lzY2FsbF9jYWxsKzcvMTFdIHN5
c2NhbGxfY2FsbCsweDcvMHhiDQpNYXIgIDYgMTA6NDI6NDYgc3lzdGVtMyBr
ZXJuZWw6IHhmc19mb3JjZV9zaHV0ZG93bihtZDAsMHg4KSBjYWxsZWQgZnJv
bSBsaW5lIDQyNjcgb2YgZmlsZSBmcy94ZnMveGZzX2JtYXAuYy4gIFJldHVy
biBhZGRyZXNzID0gMHhjMDI1NmIyOQ0KTWFyICA2IDEwOjQyOjQ2IHN5c3Rl
bTMga2VybmVsOiBGaWxlc3lzdGVtICJtZDAiOiBDb3JydXB0aW9uIG9mIGlu
LW1lbW9yeSBkYXRhIGRldGVjdGVkLiAgU2h1dHRpbmcgZG93biBmaWxlc3lz
dGVtOiBtZDANCk1hciAgNiAxMDo0Mjo0NiBzeXN0ZW0zIGtlcm5lbDogUGxl
YXNlIHVtb3VudCB0aGUgZmlsZXN5c3RlbSwgYW5kIHJlY3RpZnkgdGhlIHBy
b2JsZW0ocykNCk1hciAgNiAxMDo1MToxOSBzeXN0ZW0zIGtlcm5lbDogM3ct
OXh4eDogc2NzaTA6IEFFTjogV0FSTklORyAoMHgwNDoweDAwMjMpOiBTZWN0
b3IgcmVwYWlyIGNvbXBsZXRlZDpwb3J0PTYsIExCQT0weEU2RTAwLg0KTWFy
ICA2IDEwOjUxOjIwIHN5c3RlbTMga2VybmVsOiAzdy05eHh4OiBzY3NpMDog
QUVOOiBXQVJOSU5HICgweDA0OjB4MDAyMyk6IFNlY3RvciByZXBhaXIgY29t
cGxldGVkOnBvcnQ9NiwgTEJBPTB4RTZEQ0EuDQo=

--MP_N0nVzd=sq85jQ=VAox5cYeJ--
