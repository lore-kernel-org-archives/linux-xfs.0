Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 03:50:38 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6MAoXkQ025130
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:50:35 -0700
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8B1A1918BF3
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:51:41 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.251]) by cuda.sgi.com with ESMTP id iarW9sUMB38xi6wg for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:51:41 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id d30so456617and.75
        for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 03:51:41 -0700 (PDT)
Message-ID: <2d460de70807220351i7c468de5o33fa5aa5e9ddab99@mail.gmail.com>
Date: Tue, 22 Jul 2008 12:51:40 +0200
From: "Richard Hartmann" <richih.mailinglist@gmail.com>
Subject: Re: xfsrestore over ssh?
In-Reply-To: <48858676.3030105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <2d460de70807211317m75bc236y403d8fa57514262e@mail.gmail.com>
	 <4884F2A5.5050507@sgi.com>
	 <2d460de70807212002k1a95706ic8291e2abd8796b8@mail.gmail.com>
	 <48855B16.4050208@sgi.com>
	 <1216708397.4499.57.camel@verge.scott.net.au>
	 <48858676.3030105@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Nathan Scott <nscott@aconex.com>, Bill Kendall <wkendall@sgi.com>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 09:04, Timothy Shimmin <tes@sgi.com> wrote:

> If you could strace it then we could see what call was failing
> in path_to_fshandle().

First with -ttt to get rid of a tty allocation error, then without:

% cat root.xfs | ssh -ttt root@192.168.1.213 strace xfsrestore - /mnt/sda3
Password:
tcgetattr: Invalid argument
execve("/sbin/xfsrestore", ["xfsrestore", "-", "/mnt/sda3"], [/* 15
vars */]) = 0
brk(0)                                  = 0x808c000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f84000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=187135, ...}) = 0
mmap2(NULL, 187135, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f56000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0
\20\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=12656, ...}) = 0
mmap2(NULL, 15440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f52000
mmap2(0xb7f55000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7f55000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libhandle.so.1", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\n\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=7144, ...}) = 0
mmap2(NULL, 10164, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f4f000
mmap2(0xb7f51000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7f51000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libattr.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\f\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=12820, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f4e000
mmap2(NULL, 15680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f4a000
mmap2(0xb7f4d000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7f4d000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260e\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1356012, ...}) = 0
mmap2(NULL, 1361520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) = 0xb7dfd000
mmap2(0xb7f44000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x147) = 0xb7f44000
mmap2(0xb7f47000, 9840, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f47000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7dfc000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7dfc6f0,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f44000, 4096, PROT_READ)   = 0
munmap(0xb7f56000, 187135)              = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=16969248, ...}) = 0
mmap2(NULL, 2097152, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7bfc000
mmap2(NULL, 4096, PROT_READ, MAP_PRIVATE, 3, 0x321) = 0xb7f83000
brk(0)                                  = 0x808c000
brk(0x80ad000)                          = 0x80ad000
close(3)                                = 0
getpid()                                = 5078
getrlimit(RLIMIT_AS, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_STACK, {rlim_cur=32768*1024, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=32768*1024, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_DATA, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getcwd("/UNIONFS/root", 4096)           = 14
stat64("/var/lib/xfsdump", 0xbf9e4d70)  = -1 ENOENT (No such file or directory)
stat64("/var/xfsdump", 0xbf9e4d10)      = -1 ENOENT (No such file or directory)
open("/dev/tty", O_RDWR|O_LARGEFILE)    = 3
fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 4), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f82000
write(1, "xfsrestore: using file dump (dri"..., 52xfsrestore: using
file dump (drive_simple) strategy
) = 52
mmap2(NULL, 270336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xb7bba000
ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, {B38400 opost isig icanon echo ...}) = 0
write(1, "xfsrestore: version 2.2.45 (dump"..., 44xfsrestore: version
2.2.45 (dump format 3.0)) = 44
write(1, " - Running single-threaded\n", 27 - Running single-threaded
) = 27
time(NULL)                              = 1216723667
stat64("/mnt/sda3", {st_mode=S_IFDIR|0755, st_size=38, ...}) = 0
mkdir("/mnt/sda3/xfsrestorehousekeepingdir", 0700) = -1 EEXIST (File exists)
open("/mnt/sda3/xfsrestorehousekeepingdir/state",
O_RDWR|O_CREAT|O_LARGEFILE, 0600) = 4
fstat64(4, {st_mode=S_IFREG|0600, st_size=20480, ...}) = 0
mmap2(NULL, 20480, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0) = 0xb7f7d000
geteuid32()                             = 0
munmap(0xb7f7d000, 20480)               = 0
ftruncate64(4, 20480)                   = 0
fstat64(4, {st_mode=S_IFREG|0600, st_size=20480, ...}) = 0
mmap2(NULL, 20480, PROT_READ|PROT_WRITE, MAP_SHARED, 4, 0) = 0xb7f7d000
statfs64("/mnt/sda3", 84, {f_type=0x58465342, f_bsize=4096,
f_blocks=2201496, f_bfree=2200427, f_bavail=2200427, f_files=8816192,
f_ffree=8816187, f_fsid={2051, 0}, f_namelen=255, f_frsize=4096}) = 0
open("/mnt/sda3", O_RDONLY|O_LARGEFILE) = 5
ioctl(5, 0xc01c5868, 0xbf9e4c1c)        = -1 EINVAL (Invalid argument)
close(5)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f7c000
read(5, "# Locale name alias data base.\n#"..., 2048) = 2048
read(5, "rean.euc \tko_KR.eucKR\nko_KR\t\tko_"..., 2048) = 538
read(5, "", 2048)                       = 0
close(5)                                = 0
munmap(0xb7f7c000, 4096)                = 0
open("/usr/share/locale/de/LC_MESSAGES/libc.mo", O_RDONLY) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=123187, ...}) = 0
mmap2(NULL, 123187, PROT_READ, MAP_PRIVATE, 5, 0) = 0xb7f5e000
close(5)                                = 0
open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) = 5
fstat64(5, {st_mode=S_IFREG|0644, st_size=25700, ...}) = 0
mmap2(NULL, 25700, PROT_READ, MAP_SHARED, 5, 0) = 0xb7f57000
close(5)                                = 0
open("/usr/lib/gconv/ISO8859-15.so", O_RDONLY) = 5
read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\3\0\000"...,
512) = 512
fstat64(5, {st_mode=S_IFREG|0644, st_size=9480, ...}) = 0
mmap2(NULL, 12316, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 5,
0) = 0xb7bb6000
mmap2(0xb7bb8000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 5, 0x1) = 0xb7bb8000
close(5)                                = 0
write(1, "xfsrestore: unable to construct "..., 94xfsrestore: unable
to construct a file system handle for /mnt/sda3: Das Argument ist
ung�ltig
) = 94
rt_sigaction(SIGCHLD, {SIG_IGN}, {SIG_DFL}, 8) = 0
rt_sigaction(SIGCHLD, {SIG_IGN}, {SIG_IGN}, 8) = 0
write(1, "xfsrestore: Restore Status: ERRO"..., 34xfsrestore: Restore
Status: ERROR
) = 34
exit_group(1)                           = ?
Process 5078 detached
Connection to 192.168.1.213 closed.


#########################################
#########################################
#########################################


% cat root.xfs | ssh root@192.168.1.213 strace xfsrestore - /mnt/sda3
Password:
execve("/sbin/xfsrestore", ["xfsrestore", "-", "/mnt/sda3"], [/* 13
vars */]) = 0
brk(0)                                  = 0x808c000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f5f000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=187135, ...}) = 0
mmap2(NULL, 187135, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f31000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libuuid.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0
\20\0\000"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=12656, ...}) = 0
mmap2(NULL, 15440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f2d000
mmap2(0xb7f30000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7f30000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libhandle.so.1", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\n\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=7144, ...}) = 0
mmap2(NULL, 10164, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f2a000
mmap2(0xb7f2c000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1) = 0xb7f2c000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libattr.so.1", O_RDONLY)     = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\f\0\000"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=12820, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f29000
mmap2(NULL, 15680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xb7f25000
mmap2(0xb7f28000, 4096, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2) = 0xb7f28000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260e\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1356012, ...}) = 0
mmap2(NULL, 1361520, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) = 0xb7dd8000
mmap2(0xb7f1f000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x147) = 0xb7f1f000
mmap2(0xb7f22000, 9840, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f22000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7dd7000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7dd76f0,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7f1f000, 4096, PROT_READ)   = 0
munmap(0xb7f31000, 187135)              = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_LARGEFILE) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=16969248, ...}) = 0
mmap2(NULL, 2097152, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7bd7000
mmap2(NULL, 4096, PROT_READ, MAP_PRIVATE, 3, 0x321) = 0xb7f5e000
brk(0)                                  = 0x808c000
brk(0x80ad000)                          = 0x80ad000
close(3)                                = 0
getpid()                                = 5083
getrlimit(RLIMIT_AS, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_STACK, {rlim_cur=32768*1024, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=32768*1024, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_DATA, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_FSIZE, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
setrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getrlimit(RLIMIT_CPU, {rlim_cur=RLIM_INFINITY, rlim_max=RLIM_INFINITY}) = 0
getcwd("/UNIONFS/root", 4096)           = 14
stat64("/var/lib/xfsdump", 0xbfd418e0)  = -1 ENOENT (No such file or directory)
stat64("/var/xfsdump", 0xbfd41880)      = -1 ENOENT (No such file or directory)
open("/dev/tty", O_RDWR|O_LARGEFILE)    = -1 ENXIO (No such device or address)
dup(2)                                  = 3
fcntl64(3, F_GETFL)                     = 0x2 (flags O_RDWR)
fstat64(3, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f5d000
_llseek(3, 0, 0xbfd413a8, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
open("/usr/share/locale/locale.alias", O_RDONLY) = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=2586, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f5c000
read(4, "# Locale name alias data base.\n#"..., 2048) = 2048
read(4, "rean.euc \tko_KR.eucKR\nko_KR\t\tko_"..., 2048) = 538
read(4, "", 2048)                       = 0
close(4)                                = 0
munmap(0xb7f5c000, 4096)                = 0
open("/usr/share/locale/de/LC_MESSAGES/libc.mo", O_RDONLY) = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=123187, ...}) = 0
mmap2(NULL, 123187, PROT_READ, MAP_PRIVATE, 4, 0) = 0xb7f3e000
close(4)                                = 0
open("/usr/lib/gconv/gconv-modules.cache", O_RDONLY) = 4
fstat64(4, {st_mode=S_IFREG|0644, st_size=25700, ...}) = 0
mmap2(NULL, 25700, PROT_READ, MAP_SHARED, 4, 0) = 0xb7f37000
close(4)                                = 0
open("/usr/lib/gconv/ISO8859-15.so", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\3\0\000"...,
512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=9480, ...}) = 0
mmap2(NULL, 12316, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 4,
0) = 0xb7f33000
mmap2(0xb7f35000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 4, 0x1) = 0xb7f35000
close(4)                                = 0
write(3, "/dev/tty: Kein passendes Ger\344t b"..., 68/dev/tty: Kein
passendes Ger�t bzw. keine passende Adresse gefunden
) = 68
close(3)                                = 0
munmap(0xb7f5d000, 4096)                = 0
fstat64(1, {st_mode=S_IFSOCK|0777, st_size=0, ...}) = 0
xfsrestore: using file dump (drive_simple) strategy
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f5d000
write(1, "xfsrestore: using file dump (dri"..., 52) = 52
mmap2(NULL, 270336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0xb7b95000
xfsrestore: version 2.2.45 (dump format 3.0)write(1, "xfsrestore:
version 2.2.45 (dump"..., 44) = 44
 - Running single-threaded
write(1, " - Running single-threaded\n", 27) = 27
time(NULL)                              = 1216723678
stat64("/mnt/sda3", {st_mode=S_IFDIR|0755, st_size=38, ...}) = 0
mkdir("/mnt/sda3/xfsrestorehousekeepingdir", 0700) = -1 EEXIST (File exists)
open("/mnt/sda3/xfsrestorehousekeepingdir/state",
O_RDWR|O_CREAT|O_LARGEFILE, 0600) = 3
fstat64(3, {st_mode=S_IFREG|0600, st_size=20480, ...}) = 0
mmap2(NULL, 20480, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0xb7b90000
geteuid32()                             = 0
munmap(0xb7b90000, 20480)               = 0
ftruncate64(3, 20480)                   = 0
fstat64(3, {st_mode=S_IFREG|0600, st_size=20480, ...}) = 0
mmap2(NULL, 20480, PROT_READ|PROT_WRITE, MAP_SHARED, 3, 0) = 0xb7b90000
statfs64("/mnt/sda3", 84, {f_type=0x58465342, f_bsize=4096,
f_blocks=2201496, f_bfree=2200427, f_bavail=2200427, f_files=8816192,
f_ffree=8816187, f_fsid={2051, 0}, f_namelen=255, f_frsize=4096}) = 0
open("/mnt/sda3", O_RDONLY|O_LARGEFILE) = 4
ioctl(4, 0xc01c5868, 0xbfd4178c)        = -1 EINVAL (Invalid argument)
close(4)                                = 0
xfsrestore: unable to construct a file system handle for /mnt/sda3:
Das Argument ist ung�ltig
write(1, "xfsrestore: unable to construct "..., 94) = 94
rt_sigaction(SIGCHLD, {SIG_IGN}, xfsrestore: Restore Status: ERROR
{SIG_DFL}, 8) = 0
rt_sigaction(SIGCHLD, {SIG_IGN}, {SIG_IGN}, 8) = 0
write(1, "xfsrestore: Restore Status: ERRO"..., 34) = 34
exit_group(1)                           = ?
Process 5083 detached



Again, the German error message means 'argument invalid'


Thanks,
RIchard
