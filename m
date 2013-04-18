Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C1397F53
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 08:37:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE287304053
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 06:37:27 -0700 (PDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com
	[209.85.223.180]) by cuda.sgi.com with ESMTP id
	rjbWar0J07Ynt9Iq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 06:37:23 -0700 (PDT)
Received: by mail-ie0-f180.google.com with SMTP id qd14so3352762ieb.11
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 06:37:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab33d007-10b8-45c1-b361-c089ee4b15e8@email.android.com>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
	<CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
	<516EB6E3.9040903@sgi.com>
	<CAFZPdfguUWWPXcH_NJ30134N=39-KD422LL+k=edOWhjO2GTeA@mail.gmail.com>
	<ab33d007-10b8-45c1-b361-c089ee4b15e8@email.android.com>
Date: Thu, 18 Apr 2013 15:37:23 +0200
Message-ID: <CAFZPdfgga1HhDyycceApwrVmi4N0Jr-P8H13YCfHef4sOq6pHw@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
From: Boris Ranto <ranto.boris@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8906249669583283909=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Rich Johnston <rjohnston@sgi.com>, Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

--===============8906249669583283909==
Content-Type: multipart/alternative; boundary=047d7b3a9be6d25a9704daa2b376

--047d7b3a9be6d25a9704daa2b376
Content-Type: text/plain; charset=ISO-8859-1

Greg,

sure, currently, I use the following spec file to package it (I've trimmed
things like changelog to limit the space used):
--------------------------------------------------- SPEC FILE
-----------------------------------------------------------------------
Name:          xfstests
Version:        20130415
Release:       3.git
Summary:     xfs qa tests

Group:             misc
License:           GPL
URL:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfstests.git
Source0:          $RPM_BUILD_ROOT/SOURCES/xfstests-dev.tar.bz2
BuildRoot:
%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  autoconf, libtool, e2fsprogs-devel, xfsprogs-devel
BuildRequires:  libacl-devel, libattr-devel, libaio-devel
Requires:         bash, perl, acl, attr, bind-utils
Requires:         bc, indent, quota, xfsprogs

%description
The xfsqa test available at git://oss.sgi.com/xfs/cmds/xfstests.git.

%prep
%setup -q -n xfstests-dev

%build
autoheader
autoconf
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
# Dirty workaround, xfstests won't build if these two directories do not
exist...
mkdir -p /var/lib/xfstests/{ltp,src}

make DIST_ROOT=$RPM_BUILD_ROOT install

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc README
/var/lib/xfstests
--------------------------------------------------- SPEC FILE
-----------------------------------------------------------------------

Before the libtool was used for installation I didn't need the workaround
(mkdir -p /var/lib/xfstets/{src,ltp}). Additionally, there is a template
spec file in xfstests git repository (build/rpm/xfstests.spec.in) that you
can use.

I get the tar.bz2 package from git repository by:
git archive --format=tar --output xfstests-dev.tar --prefix=xfstests-dev/
bzip2 xfstests-dev.tar

btw: I did not originally write the file, I just maintain it, now. I
suppose that Eric Sandeen is the one who originally wrote the .spec file.

Regards,
Boris



On Thu, Apr 18, 2013 at 2:46 PM, Greg Freemyer <greg.freemyer@gmail.com>wrote:

>
>
> Boris Ranto <ranto.boris@gmail.com> wrote:
>
> >Rich,
> >
> >just as Eric guessed, I package the xfstests test suite (and that is
> >also
> >why I need the DIST_ROOT variable functioning properly). Although I can
> >currently work around the problem  by doing something like
> >
> >./configure
> >make
> >mkdir -p /var/lib/xfstets/{ltp,src}
> >make DIST_ROOT=$RPM_BUILD_ROOT install
> >
> >it certainly is not the best solution to the problem. If the test suite
> >is
> >completely independent from its location then also maybe this could
> >work (I
> >did not try it, yet and I'm still not sure it is the best solution)
> >
> >./configure --prefix=$RPM_BUILD_ROOT
> >make
> >make install
> >
> >but if that is the case then it'd probably make sense to drop the whole
> >DIST_ROOT support from install-sh script to avoid confusion and update
> >the
> >spec file in bulld/rpm/.
> >
> >Regards,
> >Boris
>
> Boris,
>
> When you get it working for packaging purposes I'd appreciate a post
> detailing what works.  I thought about packaging xfstests for opensuse a
> couple years ago but aborted the effort when I realized it was not designed
> to be installed at the time.
>
> Greg
> --
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
>

--047d7b3a9be6d25a9704daa2b376
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Greg,<br><br>sure, currently, I use the following spec fil=
e to package it (I&#39;ve trimmed things like changelog to limit the space =
used):<br>--------------------------------------------------- SPEC FILE ---=
--------------------------------------------------------------------<br>
Name:=A0=A0=A0 =A0=A0=A0=A0=A0 xfstests<br>Version:=A0=A0=A0=A0=A0=A0=A0 20=
130415<br>Release:=A0=A0=A0=A0=A0=A0 3.git<br>Summary:=A0=A0=A0=A0 xfs qa t=
ests<br><br>Group:=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0 misc<br>License:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 GPL<br>URL:=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 <a href=3D"http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstes=
ts.git">http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dxfs/cmds/xfstests.git</a>=
<br>
Source0:=A0=A0=A0=A0=A0=A0=A0=A0=A0 $RPM_BUILD_ROOT/SOURCES/xfstests-dev.ta=
r.bz2<br>BuildRoot:=A0=A0=A0=A0=A0=A0=A0 %{_tmppath}/%{name}-%{version}-%{r=
elease}-root-%(%{__id_u} -n)<br><br>BuildRequires:=A0 autoconf, libtool, e2=
fsprogs-devel, xfsprogs-devel<br>
BuildRequires:=A0 libacl-devel, libattr-devel, libaio-devel<br>Requires:=A0=
=A0=A0=A0=A0 =A0=A0 bash, perl, acl, attr, bind-utils<br>Requires:=A0=A0=A0=
=A0=A0=A0=A0=A0 bc, indent, quota, xfsprogs<br><br>%description<br>The xfsq=
a test available at git://<a href=3D"http://oss.sgi.com/xfs/cmds/xfstests.g=
it">oss.sgi.com/xfs/cmds/xfstests.git</a>.<br>
<br>%prep<br>%setup -q -n xfstests-dev<br><br>%build<br>autoheader<br>autoc=
onf<br>%configure<br>make %{?_smp_mflags}<br><br>%install<br>rm -rf $RPM_BU=
ILD_ROOT<br># Dirty workaround, xfstests won&#39;t build if these two direc=
tories do not exist...<br>
mkdir -p /var/lib/xfstests/{ltp,src}<br><br>make DIST_ROOT=3D$RPM_BUILD_ROO=
T install<br><br>%clean<br>rm -rf $RPM_BUILD_ROOT<br><br><br>%files<br>%def=
attr(-,root,root,-)<br>%doc README<br>/var/lib/xfstests<br>----------------=
----------------------------------- SPEC FILE=20
-----------------------------------------------------------------------<br>=
<br>Before the libtool was used for installation I didn&#39;t need the work=
around (mkdir -p /var/lib/xfstets/{src,ltp}). Additionally, there is a temp=
late spec file in xfstests git repository (build/rpm/<a href=3D"http://xfst=
ests.spec.in">xfstests.spec.in</a>) that you can use.<br>
<br>I get the tar.bz2 package from git repository by:<br>git archive --form=
at=3Dtar --output xfstests-dev.tar --prefix=3Dxfstests-dev/<br>bzip2 xfstes=
ts-dev.tar<br><br>btw: I did not originally write the file, I just maintain=
 it, now. I suppose that Eric Sandeen is the one who originally wrote the .=
spec file.<br>
<br>Regards,<br>Boris<br><br></div><div class=3D"gmail_extra"><br><br><div =
class=3D"gmail_quote">On Thu, Apr 18, 2013 at 2:46 PM, Greg Freemyer <span =
dir=3D"ltr">&lt;<a href=3D"mailto:greg.freemyer@gmail.com" target=3D"_blank=
">greg.freemyer@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im"><br>
<br>
Boris Ranto &lt;<a href=3D"mailto:ranto.boris@gmail.com">ranto.boris@gmail.=
com</a>&gt; wrote:<br>
<br>
&gt;Rich,<br>
&gt;<br>
&gt;just as Eric guessed, I package the xfstests test suite (and that is<br=
>
&gt;also<br>
&gt;why I need the DIST_ROOT variable functioning properly). Although I can=
<br>
&gt;currently work around the problem =A0by doing something like<br>
&gt;<br>
&gt;./configure<br>
&gt;make<br>
&gt;mkdir -p /var/lib/xfstets/{ltp,src}<br>
&gt;make DIST_ROOT=3D$RPM_BUILD_ROOT install<br>
&gt;<br>
&gt;it certainly is not the best solution to the problem. If the test suite=
<br>
&gt;is<br>
&gt;completely independent from its location then also maybe this could<br>
&gt;work (I<br>
&gt;did not try it, yet and I&#39;m still not sure it is the best solution)=
<br>
&gt;<br>
&gt;./configure --prefix=3D$RPM_BUILD_ROOT<br>
&gt;make<br>
&gt;make install<br>
&gt;<br>
&gt;but if that is the case then it&#39;d probably make sense to drop the w=
hole<br>
&gt;DIST_ROOT support from install-sh script to avoid confusion and update<=
br>
&gt;the<br>
&gt;spec file in bulld/rpm/.<br>
&gt;<br>
&gt;Regards,<br>
&gt;Boris<br>
<br>
</div>Boris,<br>
<br>
When you get it working for packaging purposes I&#39;d appreciate a post de=
tailing what works. =A0I thought about packaging xfstests for opensuse a co=
uple years ago but aborted the effort when I realized it was not designed t=
o be installed at the time.<br>

<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Greg<br>
--<br>
Sent from my Android phone with K-9 Mail. Please excuse my brevity.<br>
</font></span></blockquote></div><br></div>

--047d7b3a9be6d25a9704daa2b376--


--===============8906249669583283909==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8906249669583283909==--
