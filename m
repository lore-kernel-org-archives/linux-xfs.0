Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 21:44:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBF5hwqw014053
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 21:44:00 -0800
Received: from [134.14.55.18] (dhcp18.melbourne.sgi.com [134.14.55.18]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id QAA27012 for <xfs@oss.sgi.com>; Fri, 15 Dec 2006 16:43:05 +1100
Message-ID: <458235E9.9060209@melbourne.sgi.com>
Date: Fri, 15 Dec 2006 16:43:05 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: review: hopefully final attr2 corruption fixes
Content-Type: multipart/mixed;
 boundary="------------060905020204050902090802"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060905020204050902090802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



-------- Original Message --------
Subject: RE: attr2
Date: Fri, 15 Dec 2006 16:33:04 +1100
From: Barry Naujok <bnaujok@melbourne.sgi.com>
To: 'Russell Cattelan' <cattelan@thebarn.com>
CC: 'Timothy Shimmin' <timothy.shimmin@gmail.com>,
<chatz@melbourne.sgi.com>,   'Timothy Shimmin' <tes@sgi.com>,
<sandeen@sandeen.net>,   'David Chinner' <dgc@sgi.com>

I think I have it cracked now :)

I've cleaned up a bit more as per Russell's comments.

I also found another case of btree corruption when the last attribute is
deleted (an attr2 optimization is to completely remove the attr fork
when the last attribute is deleted).

Also, the root btree is not modified anymore when an attribute goes just
beyond the space the rest of the code thinks it needs
(XFS_BMAP_ROOT_SPACE macro).

Barry.

> -----Original Message-----
> From: Russell Cattelan [mailto:cattelan@thebarn.com] 
> Sent: Friday, 15 December 2006 2:31 PM
> To: Barry Naujok
> Cc: 'Timothy Shimmin'; chatz@melbourne.sgi.com; 'Timothy 
> Shimmin'; sandeen@sandeen.net; 'David Chinner'
> Subject: Re: attr2
> 
> Barry Naujok wrote:
> 
> 
> sorry just getting time to look at this again
> 
> 
> 
> So looking over the latest patch I'm trying to understand
> what is different from the original patch I sent out.
> 
> I guess there is the addition of the calculation of number
> of btree recs in the case of a the inode being converted
> to an attr capable format.
> I know we had talked about optimizing that space but it
> leads into the guessing game we were talking about.
> Will giving more space to attr be better or will leaving more
> space for btree block be better.
> 
> I would lean on the side of attrs are infrequent updates/additions
> but data blocks are not. So opting for an attr1 half and half 
> split once
> the inode goes btree for either fork seems simpler to me.
> And keeps the code out of the guessing game of which fork
> is better optimized by having more space.
> 
> 
> My style point comment:
> The current patch is a bit busy and has more calls to MAX,
> the maxforkoff is a bit confusing since it contains bytes during
> the calculation then converted back to the >> 3 value.
> My orginal patch has the dsize variable to help clarify bytes vs
> forkoff.
> Hmm looking closer I also think there is replicated checks for
> does the attr fit, the case statement doesn't need to deal
> with "does the attr fit" since that is handled later.
> Nothing really wrong with it but I just like the less line
> of code approach.
> 
> > 
> >
> >  
> >
> >>-----Original Message-----
> >>From: Timothy Shimmin [mailto:timothy.shimmin@gmail.com] 
> >>Sent: Friday, 15 December 2006 1:08 PM
> >>To: Barry Naujok
> >>Cc: Russell Cattelan; chatz@melbourne.sgi.com; Timothy 
> >>Shimmin; sandeen@sandeen.net; David Chinner
> >>Subject: Re: attr2
> >>
> >>Hi Barry,
> >>
> >>I don't have the tree locally (can't do an xdiff) but
> >>if we have data btree and existing forkoff then
> >>you just set the minforkoff to the existing forkoff which
> >>won't guarantee that the forkoff is not moved - previously
> >>I was returning the forkoff in that case.
> >>    
> >>
> >
> >Yes, good point. I was only thinking of the case of attrs 
> trying to get
> >enlarged. I don't believe forkoff can be increased with the existing
> >code, but with the attached change, it's now guaranteed.
> >
> >  
> >
> >>Also comments could be fixed  up a bit.
> >>
> >>The XFS_DINODE_FMT_EXTENTS comment has problems:
> >>"in in the extents form will migrate to btree"
> >>maybe you mean:
> >>"in the data extents form migrating to btree"
> >>
> >>The XFS_DINODE_FMT_BTREE comment talks about setting the
> >>forkoff but it is actually setting minforkoff.
> >>    
> >>
> >
> >Hehe, that comment is unchanged from the previous patch, but 
> I've fixed
> >it. 
> >
> >There still seems to be an issue with a non-attribute 
> data-btree case,
> >where adding a big-enough attribute will still cause the 
> btree to grow
> >another level (not corrupted though), so it seems minforkoff in that
> >case is not quite right. 
> > 
> >  
> >
> >>--Tim
> >>
> >>On 12/15/06, Barry Naujok <bnaujok@melbourne.sgi.com> wrote:
> >>    
> >>
> >>>      
> >>>
> >>>>-----Original Message-----
> >>>>From: Timothy Shimmin [mailto:timothy.shimmin@gmail.com]
> >>>>Sent: Thursday, 14 December 2006 11:57 PM
> >>>>To: Barry Naujok
> >>>>Cc: Russell Cattelan; chatz@melbourne.sgi.com; Timothy
> >>>>Shimmin; sandeen@sandeen.net; David Chinner
> >>>>Subject: Re: attr2
> >>>>
> >>>>Hi,
> >>>>
> >>>>On 12/14/06, Barry Naujok <bnaujok@melbourne.sgi.com> wrote:
> >>>>        
> >>>>
> >>>>>Made one interesting observation with the attr2 with a 
> >>>>>          
> >>>>>
> >>inode full of
> >>    
> >>
> >>>>>extents that must be migrated to btree format, if the 
> >>>>>          
> >>>>>
> >>xattr is big
> >>    
> >>
> >>>>>enough to go beyond the default forkoff (ie. < 15 in 256
> >>>>>          
> >>>>>
> >>>>byte inode) but
> >>>>        
> >>>>
> >>>>>still stay inline, it won't, but go to extents.
> >>>>>
> >>>>>Eg:
> >>>>>
> >>>>> makeextents -b4096 -n 9 <foo>
> >>>>> setfattr -n user.<32 chars> <foo>
> >>>>>
> >>>>>forkoff stays at 15, the data extents are btree as 
> >>>>>          
> >>>>>
> >>expected, and the
> >>    
> >>
> >>>>>xattr is extents rather than local (shortform).
> >>>>>
> >>>>>I think a test is needed when creating the initial attr fork:
> >>>>>
> >>>>>xfs_bmap_add_attrfork() calls xfs_attr_shortform_bytesfit()
> >>>>>          
> >>>>>
> >>>>to determine
> >>>>        
> >>>>
> >>>>>the desired forkoff. As the inode is full at this stage
> >>>>>          
> >>>>>
> >>>>without an attr
> >>>>        
> >>>>
> >>>>>fork, it will definitely go btree.
> >>>>>
> >>>>>   minforkoff = MAX(extents used, XFS_BMDR_SPACE_CALC());
> >>>>>
> >>>>>I'm thinking if the inode doesn't have attrs at this stage,
> >>>>>          
> >>>>>
> >>>>it should
> >>>>        
> >>>>
> >>>>>base the minimum on XFS_BMDR_SPACE_CALC, rather than the
> >>>>>          
> >>>>>
> >>>>space currently
> >>>>        
> >>>>
> >>>>>used by extents.
> >>>>>
> >>>>>eg:
> >>>>>
> >>>>>        minforkoff = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> >>>>>        if (dp->i_d.di_forkoff && xfs_ifork_dsize_used(dp)
> >>>>>minforkoff)
> >>>>>                minforkoff = xfs_ifork_dsize_used(dp);
> >>>>>
> >>>>>Thoughts?
> >>>>>
> >>>>>          
> >>>>>
> >>>>Did you mean this just if the data extents are in btree format?
> >>>>You don't seem to be codifying the notion of
> >>>>"full of extents that must be migrated to btree format".
> >>>>No comparison of requested attr offset with the data space used
> >>>>which would tell if we were going to have to force data
> >>>>extents to btree.
> >>>>
> >>>>I guess there is no point in both going out of line if they
> >>>>don't have to.
> >>>>However, should we favour one over the other (EA over data).
> >>>>I thought we were doing 1st come 1st served.
> >>>>If data extents fit inline currently and then they still 
> >>>>        
> >>>>
> >>fit inline
> >>    
> >>
> >>>>after EA added but
> >>>>with EA out of line, then data wins.
> >>>>But if data extents have to go out of line and we can
> >>>>have attr inline then keep attr inline.
> >>>>
> >>>>It's late so I'm probably not thinking clearly ;-)
> >>>>
> >>>>--Tim
> >>>>        
> >>>>
> >>>Ok, I have implemented and tested the attached patch. I've 
> >>>      
> >>>
> >>merged the
> >>    
> >>
> >>>function back in, distilling the core requirements.
> >>>
> >>>So, the main change from the previous patch is with data 
> >>>      
> >>>
> >>extents format
> >>    
> >>
> >>>and no attr, it checks to see if adding the default attr 
> >>>      
> >>>
> >>size (forkoff =
> >>    
> >>
> >>>15 for 256 byte inodes) will cause the data fork to be converted to
> >>>btree format. If so, it will then set the minimum offset 
> to the base
> >>>btree root size.
> >>>
> >>>So, with 7 extents, forkoff is allowed to go down to 14. 
> After that,
> >>>forkoff will be back at 15 and the attrs go out-of-line.
> >>>
> >>>With 8 extents, adding any attr at all will cause the data 
> >>>      
> >>>
> >>extents to go
> >>    
> >>
> >>>btree. This allows the attr to use up all the inode space 
> >>>      
> >>>
> >>it can up to
> >>    
> >>
> >>>the btree root.
> >>>
> >>>
> >>>
> >>>      
> >>>
> 


-- 
David Chatterton
XFS Engineering Manager
SGI Australia

--------------060905020204050902090802
Content-Type: application/octet-stream;
 name="attr2_new.diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="attr2_new.diff"

Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQpmcy94ZnMveGZzX2F0
dHIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCi0tLSBhL2Zz
L3hmcy94ZnNfYXR0ci5jCTIwMDYtMTItMTUgMTY6MjU6NDYuMDAwMDAwMDAw
ICsxMTAwCisrKyBiL2ZzL3hmcy94ZnNfYXR0ci5jCTIwMDYtMTItMTQgMTQ6
NTY6MDIuNTgwMjQ2NDc3ICsxMTAwCkBAIC0xOTksMTggKzE5OSwxNCBAQCB4
ZnNfYXR0cl9zZXRfaW50KHhmc19pbm9kZV90ICpkcCwgY29uc3QgCiAJCXJl
dHVybiAoZXJyb3IpOwogCiAJLyoKLQkgKiBEZXRlcm1pbmUgc3BhY2UgbmV3
IGF0dHJpYnV0ZSB3aWxsIHVzZSwgYW5kIGlmIGl0IHdvdWxkIGJlCi0JICog
ImxvY2FsIiBvciAicmVtb3RlIiAobm90ZTogbG9jYWwgIT0gaW5saW5lKS4K
LQkgKi8KLQlzaXplID0geGZzX2F0dHJfbGVhZl9uZXdlbnRzaXplKG5hbWVs
ZW4sIHZhbHVlbGVuLAotCQkJCQltcC0+bV9zYi5zYl9ibG9ja3NpemUsICZs
b2NhbCk7Ci0KLQkvKgogCSAqIElmIHRoZSBpbm9kZSBkb2Vzbid0IGhhdmUg
YW4gYXR0cmlidXRlIGZvcmssIGFkZCBvbmUuCiAJICogKGlub2RlIG11c3Qg
bm90IGJlIGxvY2tlZCB3aGVuIHdlIGNhbGwgdGhpcyByb3V0aW5lKQogCSAq
LwogCWlmIChYRlNfSUZPUktfUShkcCkgPT0gMCkgewotCQlpZiAoKGVycm9y
ID0geGZzX2JtYXBfYWRkX2F0dHJmb3JrKGRwLCBzaXplLCByc3ZkKSkpCisJ
CWludCBzZl9zaXplID0gc2l6ZW9mKHhmc19hdHRyX3NmX2hkcl90KSArCisJ
CQkgICAgICBYRlNfQVRUUl9TRl9FTlRTSVpFX0JZTkFNRShuYW1lbGVuLCB2
YWx1ZWxlbik7CisKKwkJaWYgKChlcnJvciA9IHhmc19ibWFwX2FkZF9hdHRy
Zm9yayhkcCwgc2Zfc2l6ZSwgcnN2ZCkpKQogCQkJcmV0dXJuKGVycm9yKTsK
IAl9CiAKQEAgLTIzMSw2ICsyMjcsMTMgQEAgeGZzX2F0dHJfc2V0X2ludCh4
ZnNfaW5vZGVfdCAqZHAsIGNvbnN0IAogCWFyZ3MuYWRkbmFtZSA9IDE7CiAJ
YXJncy5va25vZW50ID0gMTsKIAorCS8qCisJICogRGV0ZXJtaW5lIHNwYWNl
IG5ldyBhdHRyaWJ1dGUgd2lsbCB1c2UsIGFuZCBpZiBpdCB3b3VsZCBiZQor
CSAqICJsb2NhbCIgb3IgInJlbW90ZSIgKG5vdGU6IGxvY2FsICE9IGlubGlu
ZSkuCisJICovCisJc2l6ZSA9IHhmc19hdHRyX2xlYWZfbmV3ZW50c2l6ZShu
YW1lbGVuLCB2YWx1ZWxlbiwKKwkJCQkJbXAtPm1fc2Iuc2JfYmxvY2tzaXpl
LCAmbG9jYWwpOworCiAJbmJsa3MgPSBYRlNfREFFTlRFUl9TUEFDRV9SRVMo
bXAsIFhGU19BVFRSX0ZPUkspOwogCWlmIChsb2NhbCkgewogCQlpZiAoc2l6
ZSA+IChtcC0+bV9zYi5zYl9ibG9ja3NpemUgPj4gMSkpIHsKCj09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQpmcy94ZnMveGZzX2F0dHJfbGVhZi5j
Cj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQoKLS0tIGEvZnMveGZz
L3hmc19hdHRyX2xlYWYuYwkyMDA2LTEyLTE1IDE2OjI1OjQ2LjAwMDAwMDAw
MCArMTEwMAorKysgYi9mcy94ZnMveGZzX2F0dHJfbGVhZi5jCTIwMDYtMTIt
MTUgMTY6MjU6MjAuNjEyNDE2Mzg1ICsxMTAwCkBAIC0xNTAsNiArMTUwLDcg
QEAgeGZzX2F0dHJfc2hvcnRmb3JtX2J5dGVzZml0KHhmc19pbm9kZV90IAog
CWludCBvZmZzZXQ7CiAJaW50IG1pbmZvcmtvZmY7CS8qIGxvd2VyIGxpbWl0
IG9uIHZhbGlkIGZvcmtvZmYgbG9jYXRpb25zICovCiAJaW50IG1heGZvcmtv
ZmY7CS8qIHVwcGVyIGxpbWl0IG9uIHZhbGlkIGZvcmtvZmYgbG9jYXRpb25z
ICovCisJaW50IGRzaXplOwkKIAl4ZnNfbW91bnRfdCAqbXAgPSBkcC0+aV9t
b3VudDsKIAogCW9mZnNldCA9IChYRlNfTElUSU5PKG1wKSAtIGJ5dGVzKSA+
PiAzOyAvKiByb3VuZGVkIGRvd24gKi8KQEAgLTE2OSw4ICsxNzAsNDMgQEAg
eGZzX2F0dHJfc2hvcnRmb3JtX2J5dGVzZml0KHhmc19pbm9kZV90IAogCQly
ZXR1cm4gMDsKIAl9CiAKLQkvKiBkYXRhIGZvcmsgYnRyZWUgcm9vdCBjYW4g
aGF2ZSBhdCBsZWFzdCB0aGlzIG1hbnkga2V5L3B0ciBwYWlycyAqLwotCW1p
bmZvcmtvZmYgPSBNQVgoZHAtPmlfZGYuaWZfYnl0ZXMsIFhGU19CTURSX1NQ
QUNFX0NBTEMoTUlOREJUUFRSUykpOworCWRzaXplID0gZHAtPmlfZGYuaWZf
Ynl0ZXM7CisJCisJc3dpdGNoIChkcC0+aV9kLmRpX2Zvcm1hdCkgeworCWNh
c2UgWEZTX0RJTk9ERV9GTVRfRVhURU5UUzoKKwkJLyogCisJCSAqIElmIHRo
ZXJlIGlzIG5vIGF0dHIgZm9yayBhbmQgdGhlIGRhdGEgZm9yayBpcyBleHRl
bnRzLCAKKwkJICogZGV0ZXJtaW5lIGlmIGNyZWF0aW5nIHRoZSBkZWZhdWx0
IGF0dHIgZm9yayB3aWxsIHJlc3VsdCAKKwkJICogaW4gdGhlIGV4dGVudHMg
Zm9ybSBtaWdyYXRpbmcgdG8gYnRyZWUuIElmIHNvLCB0aGUgCisJCSAqIG1p
bmltdW0gb2Zmc2V0IG9ubHkgbmVlZHMgdG8gYmUgdGhlIHNwYWNlIHJlcXVp
cmVkIGZvciAKKwkJICogdGhlIGJ0cmVlIHJvb3QuCisJCSAqLyAKKwkJaWYg
KCFkcC0+aV9kLmRpX2ZvcmtvZmYgJiYgZHAtPmlfZGYuaWZfYnl0ZXMgPiBt
cC0+bV9hdHRyb2Zmc2V0KQorCQkJZHNpemUgPSBYRlNfQk1EUl9TUEFDRV9D
QUxDKE1JTkRCVFBUUlMpOworCQlicmVhazsKKwkJCisJY2FzZSBYRlNfRElO
T0RFX0ZNVF9CVFJFRToKKwkJLyoKKwkJICogSWYgaGF2ZSBkYXRhIGJ0cmVl
IHRoZW4ga2VlcCBmb3Jrb2ZmIGlmIHdlIGhhdmUgb25lLAorCQkgKiBvdGhl
cndpc2Ugd2UgYXJlIGFkZGluZyBhIG5ldyBhdHRyLCBzbyB0aGVuIHdlIHNl
dCAKKwkJICogbWluZm9ya29mZiB0byB3aGVyZSB0aGUgYnRyZWUgcm9vdCBj
YW4gZmluaXNoIHNvIHdlIGhhdmUgCisJCSAqIHBsZW50eSBvZiByb29tIGZv
ciBhdHRycworCQkgKi8KKwkJaWYgKGRwLT5pX2QuZGlfZm9ya29mZikgewor
CQkJaWYgKG9mZnNldCA8IGRwLT5pX2QuZGlfZm9ya29mZikgCisJCQkJcmV0
dXJuIDA7CisJCQllbHNlIAorCQkJCXJldHVybiBkcC0+aV9kLmRpX2Zvcmtv
ZmY7CisJCX0gZWxzZQorCQkJZHNpemUgPSBYRlNfQk1BUF9CUk9PVF9TUEFD
RShkcC0+aV9kZi5pZl9icm9vdCk7CisJCWJyZWFrOworCX0KKwkKKwkvKiAK
KwkgKiBBIGRhdGEgZm9yayBidHJlZSByb290IG11c3QgaGF2ZSBzcGFjZSBm
b3IgYXQgbGVhc3QgCisJICogTUlOREJUUFRSUyBrZXkvcHRyIHBhaXJzIGlm
IHRoZSBkYXRhIGZvcmsgaXMgc21hbGwgb3IgZW1wdHkuCisJICovCisJbWlu
Zm9ya29mZiA9IE1BWChkc2l6ZSwgWEZTX0JNRFJfU1BBQ0VfQ0FMQyhNSU5E
QlRQVFJTKSk7CiAJbWluZm9ya29mZiA9IHJvdW5kdXAobWluZm9ya29mZiwg
OCkgPj4gMzsKIAogCS8qIGF0dHIgZm9yayBidHJlZSByb290IGNhbiBoYXZl
IGF0IGxlYXN0IHRoaXMgbWFueSBrZXkvcHRyIHBhaXJzICovCkBAIC0zMzYs
NyArMzcyLDggQEAgeGZzX2F0dHJfc2hvcnRmb3JtX3JlbW92ZSh4ZnNfZGFf
YXJnc190IAogCSAqLwogCXRvdHNpemUgLT0gc2l6ZTsKIAlpZiAodG90c2l6
ZSA9PSBzaXplb2YoeGZzX2F0dHJfc2ZfaGRyX3QpICYmICFhcmdzLT5hZGRu
YW1lICYmCi0JICAgIChtcC0+bV9mbGFncyAmIFhGU19NT1VOVF9BVFRSMikp
IHsKKwkgICAgKG1wLT5tX2ZsYWdzICYgWEZTX01PVU5UX0FUVFIyKSAmJiAK
KwkgICAgKGRwLT5pX2QuZGlfZm9ybWF0ICE9IFhGU19ESU5PREVfRk1UX0JU
UkVFKSkgewogCQkvKgogCQkgKiBMYXN0IGF0dHJpYnV0ZSBub3cgcmVtb3Zl
ZCwgcmV2ZXJ0IHRvIG9yaWdpbmFsCiAJCSAqIGlub2RlIGZvcm1hdCBtYWtp
bmcgYWxsIGxpdGVyYWwgYXJlYSBhdmFpbGFibGUKQEAgLTc0OCw2ICs3ODUs
NyBAQCB4ZnNfYXR0cl9zaG9ydGZvcm1fYWxsZml0KHhmc19kYWJ1Zl90ICpi
CiAJCQkJKyBiZTE2X3RvX2NwdShuYW1lX2xvYy0+dmFsdWVsZW4pOwogCX0K
IAlpZiAoKGRwLT5pX21vdW50LT5tX2ZsYWdzICYgWEZTX01PVU5UX0FUVFIy
KSAmJgorCSAgICAoZHAtPmlfZC5kaV9mb3JtYXQgIT0gWEZTX0RJTk9ERV9G
TVRfQlRSRUUpICYmCiAJICAgIChieXRlcyA9PSBzaXplb2Yoc3RydWN0IHhm
c19hdHRyX3NmX2hkcikpKQogCQlyZXR1cm4oLTEpOwogCXJldHVybih4ZnNf
YXR0cl9zaG9ydGZvcm1fYnl0ZXNmaXQoZHAsIGJ5dGVzKSk7CkBAIC03ODYs
NiArODI0LDcgQEAgeGZzX2F0dHJfbGVhZl90b19zaG9ydGZvcm0oeGZzX2Rh
YnVmX3QgKgogCiAJaWYgKGZvcmtvZmYgPT0gLTEpIHsKIAkJQVNTRVJUKGRw
LT5pX21vdW50LT5tX2ZsYWdzICYgWEZTX01PVU5UX0FUVFIyKTsKKwkJQVNT
RVJUKGRwLT5pX2QuZGlfZm9ybWF0ICE9IFhGU19ESU5PREVfRk1UX0JUUkVF
KTsKIAogCQkvKgogCQkgKiBMYXN0IGF0dHJpYnV0ZSB3YXMgcmVtb3ZlZCwg
cmV2ZXJ0IHRvIG9yaWdpbmFsCgo9PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT0KZnMveGZzL3hmc19ibWFwLmMKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09CgotLS0gYS9mcy94ZnMveGZzX2JtYXAuYwkyMDA2LTEyLTE1
IDE2OjI1OjQ2LjAwMDAwMDAwMCArMTEwMAorKysgYi9mcy94ZnMveGZzX2Jt
YXAuYwkyMDA2LTEyLTE0IDE0OjU2OjAyLjU5NDY1ODAzOCArMTEwMApAQCAt
MzU0Myw2ICszNTQzLDcgQEAgeGZzX2JtYXBfZm9ya29mZl9yZXNldCgKIAlp
ZiAod2hpY2hmb3JrID09IFhGU19BVFRSX0ZPUksgJiYKIAkgICAgKGlwLT5p
X2QuZGlfZm9ybWF0ICE9IFhGU19ESU5PREVfRk1UX0RFVikgJiYKIAkgICAg
KGlwLT5pX2QuZGlfZm9ybWF0ICE9IFhGU19ESU5PREVfRk1UX1VVSUQpICYm
CisJICAgIChpcC0+aV9kLmRpX2Zvcm1hdCAhPSBYRlNfRElOT0RFX0ZNVF9C
VFJFRSkgJiYKIAkgICAgKChtcC0+bV9hdHRyb2Zmc2V0ID4+IDMpID4gaXAt
PmlfZC5kaV9mb3Jrb2ZmKSkgewogCQlpcC0+aV9kLmRpX2ZvcmtvZmYgPSBt
cC0+bV9hdHRyb2Zmc2V0ID4+IDM7CiAJCWlwLT5pX2RmLmlmX2V4dF9tYXgg
PSBYRlNfSUZPUktfRFNJWkUoaXApIC8KDQo=

--------------060905020204050902090802--
