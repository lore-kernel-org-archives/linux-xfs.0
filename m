Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 05:53:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KCrc52017126
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:53:38 -0700
Received: from rbox3.erasmusmc.nl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D271512B78DE
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:54:25 -0700 (PDT)
Received: from rbox3.erasmusmc.nl (rbox3.erasmusmc.nl [156.83.10.13]) by cuda.sgi.com with ESMTP id EHZufdUgL3RHziWj for <xfs@oss.sgi.com>; Tue, 20 May 2008 05:54:25 -0700 (PDT)
Received: from localhost (localhost.erasmusmc.nl [127.0.0.1])
	by rbox3.erasmusmc.nl (Postfix) with ESMTP id 72EDDEB0EB4
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 14:54:24 +0200 (CEST)
Received: from rbox3.erasmusmc.nl ([127.0.0.1])
	by localhost (rbox3.erasmusmc.nl [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id yFBpkST63K+i for <xfs@oss.sgi.com>;
	Tue, 20 May 2008 14:54:24 +0200 (CEST)
Received: from bioinf-mir.erasmusmc.nl (bioinf-mir.erasmusmc.nl [10.92.2.192])
	by rbox3.erasmusmc.nl (Postfix) with ESMTP id 3B587EB0EAC
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 14:54:24 +0200 (CEST)
Message-ID: <4832C9DD.6090700@erasmusmc.nl>
Date: Tue, 20 May 2008 14:53:49 +0200
From: Mirjam van den Hout - van Vroonhoven <m.vandenhout@erasmusmc.nl>
Reply-To: m.vandenhout@erasmusmc.nl
MIME-Version: 1.0
Subject: Adapted specfile to make kernel-module-xfs rpm build for a RHEL4
 largesmp kernel
Content-Type: multipart/mixed;
 boundary="------------040207080205040308050205"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------040207080205040308050205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello XFS team,

In order to make XFS work on Redhat Enterprise Linux 4, using the stock 
RH largesmp kernel (our server has 16 CPU's) I had to adapt the spec 
file for the kernel-module-xfs source rpm you offer for download at
ftp://oss.sgi.com/projects/xfs/download/testing/RHEL4/kernel-module-xfs-2.6.9-22.EL-0.1-1.src.rpm

The issue is that largesmp was not recognized as a kernel type, and with 
the original specfile an RPM was build with a dependency
"requires kernel-smp = 2.6.9-67.0.1.ELlarge" where the dependency should 
have been "requires kernel-largesmp = 2.6.9-67.0.1".

The fix was to add "largesmp" to the list of defined kernel_type at the 
top of the .spec file. I also fixed a typo in this list (default instead 
of deault). The new fixed spec file (kernel-module-xfs.spec), the 
original spec file (kernel-module-xfs.spec.orig) and a diff between the 
two (kernel-module-xfs.spec.patch are attached to this email.

For other users, it might be useful to include this in the next release.


				Kind regards,

					Mirjam van den Hout
-- 
Dr. Mirjam van den Hout - van Vroonhoven
	system administrator/programmer, dept. of Bioinformatics
	Erasmus Medical Center, Rotterdam, The Netherlands
	Room Number Ee 15.32, phone +31-10-703 81 11
Web: 	http://www.erasmusmc.nl/bioinformatics/
E-mail: m.vandenhout@erasmusmc.nl

--------------040207080205040308050205
Content-Type: text/plain;
 name="kernel-module-xfs.spec"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-module-xfs.spec"

# Spec file for xfs linux-2.6 kernel modules

%define module_name xfs

# Make a kernel-modules-xfs-source package to go with kernel-source?
# XXX ERS maybe a -devel package makes more sense for RH
%define build_source_pkg 0

# Work out kernel uname, version, release, type, etc for provides/requires

%define kernel_uname %(grep -s UTS_RELEASE %{kernel_topdir}/include/linux/version.h | awk '{print $3}' | sed s/\\"//g)

# kernel_type is everything else at the end of the uname
%define kernel_type %(echo %{kernel_uname} | grep -o "default$\\|smp$\\|bigsmp$\\|bigmem$\\|debug$\\|hugemem$\\|largesmp$\\|sn2$")
# kernel_type, IF it exists, has leading "-" in the kernel rpm name
%define rpm_kernel_type %(test ! -z "%{kernel_type}" && echo -%{kernel_type})

%define kernel_ver %(echo %{kernel_uname} | awk -F - '{print $1}')
%define kernel_rel %(echo %{kernel_uname} | awk -F - '{print $2}' | sed -e "s/%{kernel_type}$//")

Summary		: XFS filesystem kernel modules
Name		: kernel-module-%{module_name}-%{kernel_uname}
Version		: 0.1
Release		: 1
Vendor		: Silicon Graphics, Inc.
Packager	: Silicon Graphics, Inc.
License		: GPL
Group		: System Environment/Kernel
URL		: http://oss.sgi.com/projects/xfs
BuildRoot	: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Provides	: kernel-module
Provides	: kernel-module-%{module_name} = %{version}-%{release}
Requires	: kernel%{rpm_kernel_type} = %{kernel_ver}-%{kernel_rel}
Requires	: /sbin/depmod

# different name here
Source0		: %{module_name}-kern.tar.gz
Source1		: config.xfs

# Allow the code to build as an out-of-tree module
Patch0		: %{module_name}_ootbuild.patch
# This patchset is for making the xfs codebase in sles9 work
# with an RHEL4 kernel.
Patch1		: xfs_qsort.patch
Patch2		: xfs_proc_args.patch
Patch3		: xfs_export_ops.patch
Patch4		: xfs_write_inode_return.patch
Patch5		: xfs_dmapi_address_space.patch
Patch6		: xfs_direct_io_locking.patch

# suppress debuginfo packages for now
%define debug_package %{nil}

%description
The XFS(tm) Filesystem from Silicon Graphics, Inc.
XFS is a highly scalable, high-performance journaling filesystem that provides 
rapid recovery from system crashes.

%if %{build_source_pkg}
%package -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
Summary		: The source code for the XFS filesystem kernel module.
Group		: Development/System
Requires	: kernel-source = %{kernel_ver}-%{kernel_rel}

%description -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
The %{module_name}-modules-source package contains the source code files for the XFS
filesystem.  When installed, this will populate the fs/%{module_name} subdirectory
of the matching kernel-source RPM.
%endif

%prep

%setup -n %{module_name}
%patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1
%patch6 -p1
cp %{SOURCE1} .

%build
make TOPDIR=%{kernel_topdir} modules

%install
make TOPDIR=%{kernel_topdir} DMAPI_TOPDIR=%{dmapi_topdir} INSTALL_MOD_PATH=$RPM_BUILD_ROOT modules_install

# Make clean & copy files over for source package
%if %{build_source_pkg}
make TOPDIR=%{kernel_topdir} clean
mkdir -p $RPM_BUILD_ROOT/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
cp -aR * $RPM_BUILD_ROOT/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
%endif

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT ]

%files
%defattr(644,root,root,755)
/lib/modules/%{kernel_uname}/extra

%if %{build_source_pkg}
%ifarch i386 ia64 x86_64
%files -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
%defattr(644,root,root,755)
/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
%endif
%endif

# Note, this mkinitrd command is unique to RH I believe

%post
if [ -e /boot/System.map-%{kernel_uname} ]; then
	/sbin/depmod -ae -F /boot/System.map-%{kernel_uname} %{kernel_uname}
fi

if (stat -f / | grep -q 0x58465342) || (stat -f / | grep -q XFS); then
  echo "It appears that your root filesytem is on XFS."
  echo "Creating a new initrd /boot/initrd-%{kernel_uname}.img"
  echo "for kernel %{kernel_uname} with command:"
  echo "  /sbin/mkinitrd -f /boot/initrd-%{kernel_uname}.img %{kernel_uname}"
  echo "If you use lilo, you should re-run the lilo command."

  /sbin/mkinitrd -f /boot/initrd-%{kernel_uname}.img %{kernel_uname}
fi

echo "#################################################################"
echo "#                                                               #"
echo "#                        NOTICE                                 #"
echo "# This xfs module rpm has been provided for testing purposes    #"
echo "# only.  It is believed to be functional, but it has not been   #"
echo "# heavily tested.  In particular, you may have issues with the  #"
echo "# 4KSTACKS option on RHEL4 ia32 kernels, depending on your IO   #"
echo "# hardware, layering, nfs usage, etc.                           #"
echo "#                                                               #"
echo "# Please do NOT report any problems with this module, or with   #"
echo "# the kernel when this module is loaded, to Red Hat.            #"
echo "# You may report issues to the linux-xfs@oss.sgi.com list.      #"
echo "# (Please also report successes!)                               #"
echo "#                                                               #"
echo "#################################################################"


# Could do an "are you sure? y/n" thing but that might get annoying.
%preun
if (stat -f / | grep -q 0x58465342) || (stat -f / | grep -q XFS); then
  echo "It appears that your root filesystem is on XFS."
  echo "Note that kernel %{kernel_uname} might not"
  echo "boot without this package."
fi

%postun
if [ -e /boot/System.map-%{kernel_uname} ]; then
       /sbin/depmod -ae -F /boot/System.map-%{kernel_uname} %{kernel_uname}
fi


--------------040207080205040308050205
Content-Type: text/plain;
 name="kernel-module-xfs.spec.orig"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-module-xfs.spec.orig"

# Spec file for xfs linux-2.6 kernel modules

%define module_name xfs

# Make a kernel-modules-xfs-source package to go with kernel-source?
# XXX ERS maybe a -devel package makes more sense for RH
%define build_source_pkg 0

# Work out kernel uname, version, release, type, etc for provides/requires

%define kernel_uname %(grep -s UTS_RELEASE %{kernel_topdir}/include/linux/version.h | awk '{print $3}' | sed s/\\"//g)

# kernel_type is everything else at the end of the uname
%define kernel_type %(echo %{kernel_uname} | grep -o "deault$\\|smp$\\|bigsmp$\\|bigmem$\\|debug$\\|hugemem$\\|sn2$")
# kernel_type, IF it exists, has leading "-" in the kernel rpm name
%define rpm_kernel_type %(test ! -z "%{kernel_type}" && echo -%{kernel_type})

%define kernel_ver %(echo %{kernel_uname} | awk -F - '{print $1}')
%define kernel_rel %(echo %{kernel_uname} | awk -F - '{print $2}' | sed -e "s/%{kernel_type}$//")

Summary		: XFS filesystem kernel modules
Name		: kernel-module-%{module_name}-%{kernel_uname}
Version		: 0.1
Release		: 1
Vendor		: Silicon Graphics, Inc.
Packager	: Silicon Graphics, Inc.
License		: GPL
Group		: System Environment/Kernel
URL		: http://oss.sgi.com/projects/xfs
BuildRoot	: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Provides	: kernel-module
Provides	: kernel-module-%{module_name} = %{version}-%{release}
Requires	: kernel%{rpm_kernel_type} = %{kernel_ver}-%{kernel_rel}
Requires	: /sbin/depmod

# different name here
Source0		: %{module_name}-kern.tar.gz
Source1		: config.xfs

# Allow the code to build as an out-of-tree module
Patch0		: %{module_name}_ootbuild.patch
# This patchset is for making the xfs codebase in sles9 work
# with an RHEL4 kernel.
Patch1		: xfs_qsort.patch
Patch2		: xfs_proc_args.patch
Patch3		: xfs_export_ops.patch
Patch4		: xfs_write_inode_return.patch
Patch5		: xfs_dmapi_address_space.patch
Patch6		: xfs_direct_io_locking.patch

# suppress debuginfo packages for now
%define debug_package %{nil}

%description
The XFS(tm) Filesystem from Silicon Graphics, Inc.
XFS is a highly scalable, high-performance journaling filesystem that provides 
rapid recovery from system crashes.

%if %{build_source_pkg}
%package -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
Summary		: The source code for the XFS filesystem kernel module.
Group		: Development/System
Requires	: kernel-source = %{kernel_ver}-%{kernel_rel}

%description -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
The %{module_name}-modules-source package contains the source code files for the XFS
filesystem.  When installed, this will populate the fs/%{module_name} subdirectory
of the matching kernel-source RPM.
%endif

%prep

%setup -n %{module_name}
%patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1
%patch4 -p1
%patch5 -p1
%patch6 -p1
cp %{SOURCE1} .

%build
make TOPDIR=%{kernel_topdir} modules

%install
make TOPDIR=%{kernel_topdir} DMAPI_TOPDIR=%{dmapi_topdir} INSTALL_MOD_PATH=$RPM_BUILD_ROOT modules_install

# Make clean & copy files over for source package
%if %{build_source_pkg}
make TOPDIR=%{kernel_topdir} clean
mkdir -p $RPM_BUILD_ROOT/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
cp -aR * $RPM_BUILD_ROOT/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
%endif

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT ]

%files
%defattr(644,root,root,755)
/lib/modules/%{kernel_uname}/extra

%if %{build_source_pkg}
%ifarch i386 ia64 x86_64
%files -n kernel-module-%{module_name}-%{kernel_ver}-%{kernel_rel}-source
%defattr(644,root,root,755)
/usr/src/linux-%{kernel_ver}-%{kernel_rel}/fs/%{module_name}
%endif
%endif

# Note, this mkinitrd command is unique to RH I believe

%post
if [ -e /boot/System.map-%{kernel_uname} ]; then
	/sbin/depmod -ae -F /boot/System.map-%{kernel_uname} %{kernel_uname}
fi

if (stat -f / | grep -q 0x58465342) || (stat -f / | grep -q XFS); then
  echo "It appears that your root filesytem is on XFS."
  echo "Creating a new initrd /boot/initrd-%{kernel_uname}.img"
  echo "for kernel %{kernel_uname} with command:"
  echo "  /sbin/mkinitrd -f /boot/initrd-%{kernel_uname}.img %{kernel_uname}"
  echo "If you use lilo, you should re-run the lilo command."

  /sbin/mkinitrd -f /boot/initrd-%{kernel_uname}.img %{kernel_uname}
fi

echo "#################################################################"
echo "#                                                               #"
echo "#                        NOTICE                                 #"
echo "# This xfs module rpm has been provided for testing purposes    #"
echo "# only.  It is believed to be functional, but it has not been   #"
echo "# heavily tested.  In particular, you may have issues with the  #"
echo "# 4KSTACKS option on RHEL4 ia32 kernels, depending on your IO   #"
echo "# hardware, layering, nfs usage, etc.                           #"
echo "#                                                               #"
echo "# Please do NOT report any problems with this module, or with   #"
echo "# the kernel when this module is loaded, to Red Hat.            #"
echo "# You may report issues to the linux-xfs@oss.sgi.com list.      #"
echo "# (Please also report successes!)                               #"
echo "#                                                               #"
echo "#################################################################"


# Could do an "are you sure? y/n" thing but that might get annoying.
%preun
if (stat -f / | grep -q 0x58465342) || (stat -f / | grep -q XFS); then
  echo "It appears that your root filesystem is on XFS."
  echo "Note that kernel %{kernel_uname} might not"
  echo "boot without this package."
fi

%postun
if [ -e /boot/System.map-%{kernel_uname} ]; then
       /sbin/depmod -ae -F /boot/System.map-%{kernel_uname} %{kernel_uname}
fi


--------------040207080205040308050205
Content-Type: text/x-patch;
 name="kernel-module-xfs.spec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-module-xfs.spec.patch"

14c14
< %define kernel_type %(echo %{kernel_uname} | grep -o "deault$\\|smp$\\|bigsmp$\\|bigmem$\\|debug$\\|hugemem$\\|sn2$")
---
> %define kernel_type %(echo %{kernel_uname} | grep -o "default$\\|smp$\\|bigsmp$\\|bigmem$\\|debug$\\|hugemem$\\|largesmp$\\|sn2$")

--------------040207080205040308050205--
