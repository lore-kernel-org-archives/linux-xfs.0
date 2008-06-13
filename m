Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jun 2008 22:38:24 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5D5cKKj030781
	for <xfs@oss.sgi.com>; Thu, 12 Jun 2008 22:38:20 -0700
Message-ID: <48520704.8050903@melbourne.sgi.com>
Date: Fri, 13 Jun 2008 15:35:00 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: Filestreams (and 64bit inodes)
References: <484B15A3.4030505@sauce.co.nz> <484CA425.3080606@sandeen.net> <484DDDB3.70000@sgi.com> <484F0998.90306@sauce.co.nz> <484F2CD7.9070506@sgi.com> <484F452A.8090909@sandeen.net> <48512A34.1020604@sandeen.net> <4851CD32.7080106@melbourne.sgi.com> <4851E774.2070401@sgi.com> <4851EC2D.6010504@melbourne.sgi.com>
In-Reply-To: <4851EC2D.6010504@melbourne.sgi.com>
Content-Type: multipart/mixed;
 boundary="------------020704050307000508040701"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: markgw@sgi.com, Timothy Shimmin <tes@sgi.com>, Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020704050307000508040701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg Banks wrote:
> Mark Goodwin wrote:
>   
>> Greg Banks wrote:
>>     
>>> Eric Sandeen wrote:
>>>       
>>>>    4070 29.1% are scripts (shell, perl, whatever)
>>>>    6598 47.2% don't use any stat() family calls at all
>>>>    1829 13.1% use 32-bit stat() family interfaces only
>>>>    1312  9.4% use 64-bit stat64() family interfaces only
>>>>     180  1.3% use both 32-bit and 64-bit stat() family interfaces
>>>>
>>>>         
>>> Ouch.  That's over two thousand executables to patch, rebuild, and ship.
>>>       
>>>> list of packages, sorted by the semi-lame "number of files in package
>>>> which call a 32-bit stat variant" metric:
>>>>
>>>> http://sandeen.fedorapeople.org/stat32-ers
>>>>         
>> struct dirent has an embedded ino_t too, so for completeness we should
>> also
>> be looking for readdir(), readdir64(), getdirentries(),
>> getdirentries64(), etc.
>>     
> Good point.  Looking in the code, it seems the getdents common code in
> glibc will fail with EOVERFLOW if the inode number gets truncated during
> 64b-32b translation, just like the stat() family.  
Experiment confirms this behaviour, using a small wrapper program around
opendir/readdir/closedir:

heave:~/stat64/mnt # ../myls64
idx       d_ino      d_off d_type d_name
--- ---------------- ----- ------ ------
  0 0000000000000080     4      0 .
  1 0000000000000080     6      0 ..
  2 0000000000000083     8      0 d0
  3 0000000080000080    10      0 d1
  4 0000000100000080    12      0 d2
  5 0000000180000080    14      0 d3
  6 0000000200000080    16      0 d4
  7 0000000280000080    18      0 d5
  8 0000000300000080    20      0 d6
  9 0000000380000080    22      0 d7
 10 0000000400000080    24      0 d8
 11 0000000480000080    26      0 d9
 12 0000000500000080    28      0 d10
 13 0000000580000080    30      0 d11
 14 0000000600000080    32      0 d12
 15 0000000680000080    34      0 d13
 16 0000000700000080    36      0 d14
 17 0000000780000080    38      0 d15
 18 0000000800000080    40      0 d16
 19 0000000880000080    42      0 d17
 20 0000000900000080    44      0 d18
 21 0000000980000080    46      0 d19
 22 0000000a00000080    48      0 d20
 23 0000000a80000080    50      0 d21
 24 0000000b00000080    52      0 d22
 25 0000000b80000080    54      0 d23
 26 0000000c00000080    56      0 d24
 27 0000000c80000080    58      0 d25
 28 0000000d00000080    60      0 d26
 29 0000000d80000080    62      0 d27
 30 0000000e00000080    64      0 d28
 31 0000000e80000080    66      0 d29
 32 0000000f00000080    68      0 d30
 33 0000000f80000080    70      0 d31
 34 0000001000080080    72      0 d32
 35 0000001080000080    74      0 d33
 36 0000001100000080    76      0 d34
 37 0000001180000080    78      0 d35
 38 0000001200000080    80      0 d36
 39 0000001280000080    82      0 d37
 40 0000001300000080    84      0 d38
 41 0000001380000080    86      0 d39
 42 0000001400000080    88      0 d40
 43 0000001480000080    90      0 d41
 44 0000001500000080    92      0 d42
 45 0000001580000080    94      0 d43
 46 0000001600000080    96      0 d44
 47 0000001680000080    98      0 d45
 48 0000001700000080   100      0 d46
 49 0000001780000080   102      0 d47
 50 0000001800000080   104      0 d48
 51 0000001880000080   106      0 d49
 52 0000001900000080   108      0 d50
 53 0000001980000080   110      0 d51
 54 0000001a00000080   112      0 d52
 55 0000001a80000080   114      0 d53
 56 0000001b00000080   116      0 d54
 57 0000001b80000080   118      0 d55
 58 0000001c00000080   120      0 d56
 59 0000001c80000080   122      0 d57
 60 0000001d00000080   124      0 d58
 61 0000001d80000080   126      0 d59
 62 0000001e00000080   128      0 d60
 63 0000001e80000080   130      0 d61
 64 0000001f00000080   132      0 d62
 65 0000001f80000080   512      0 d63


heave:~/stat64/mnt # ../myls32
idx       d_ino      d_off d_type d_name
--- ---------------- ----- ------ ------
  0 0000000000000080     4      0 .
  1 0000000000000080     6      0 ..
  2 0000000000000083     8      0 d0
  3 0000000080000080    10      0 d1
.: Value too large for defined data type


heave:~/stat64/mnt # strace -s1024 ../myls32
execve("../myls32", ["../myls32"], [/* 60 vars */]) = 0
[ Process PID=12640 runs in 32 bit mode. ]
...
open(".", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3
...
write(1, "idx       d_ino      d_off d_type d_name\n", 41) = 41
write(1, "--- ---------------- ----- ------ ------\n", 41) = 41
getdents64(3, /* 66 entries */, 4096)   = 1584
_llseek(3, 10, [10], SEEK_SET)          = 0
write(1, "  0 0000000000000080     4      0 .\n", 36) = 36
write(1, "  1 0000000000000080     6      0 ..\n", 37) = 37
write(1, "  2 0000000000000083     8      0 d0\n", 37) = 37
write(1, "  3 0000000080000080    10      0 d1\n", 37) = 37
getdents64(3, /* 62 entries */, 4096)   = 1488
...
write(4, ".: Value too large for defined data type\n", 41) = 41
...
close(3)                                = 0
exit_group(0)                           = ?
Process 12640 detached



I also confirmed that using readdir64() allows the 32b app to work.

Of course, the glibc readdir() interface makes it extra hard for the
caller to tell the difference between an error and a normal EOF.  In
both cases, NULL is returned.  In the error case, errno is set.  In the
EOF case, errno is unchanged.  In the success case, EOF is also
unchanged.  So to detect the error from readdir() the application writer
needs to do something like:

DIR *dir;
struct direntry *de;
...
errno = 0;
while ((de = readdir(dir)) != NULL)
{
    // handle entry
    errno = 0;
}
if (errno)
{
     // handle error
}

Otherwise the directory traversal just finishes early with no error
reported.  I'll bet that's what all the apps do :-)

> I'll need to improve
> the scanning tool :-)
Attached.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.


--------------020704050307000508040701
Content-Type: application/x-perl;
 name="summarise-stat64-2.pl"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="summarise-stat64-2.pl"

#!/usr/bin/perl
#
# A Perl script for evaluating and summarising which executables in
# the given directories depend on the old 32-bit stat() family APIs.
#
# Version 2: detects use of old 32-bit readdir() calls.
#
# Usage: summariese-stat64.pl directory [...]
#
# Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
# By Greg Banks <gnb@melbourne.sgi.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

use strict;
use warnings;

my @pathnames;		# file and directories to read, from the commandline
my @results;		# array of { path, used32, used64, not_exe, no_perm } hashes
my $verbose = 0;

sub usage
{
    print STDERR "Usage: summarise-stat64 [--verbose] file_or_directory...\n";
    exit 1;
}

# Parse arguments
foreach my $a (@ARGV)
{
    if ($a eq '--verbose' || $a eq '-v')
    {
	$verbose++;
    }
    elsif ($a =~ m/^-/)
    {
	usage;
    }
    else
    {
	push(@pathnames,$a);
    }
}
usage unless scalar(@pathnames);

# Function to scan a file
sub scan_file
{
	my ($path) = @_;
	my $fh;

	my %res =
	(
		path => $path,
		used32 => 0,
		used64 => 0,
		not_exe => 0,
		no_perm => 0,
	);

	open $fh,'-|', "nm -uD \"$path\" 2>&1"
		or return;
	while (<$fh>)
	{
		chomp;

		if (m/File format not recognized/)
		{
			$res{not_exe} = 1;
		}
		elsif (m/Permission denied/)
		{
			$res{no_perm} = 1;
		}
		elsif (m/^\s+U __(|l|f)xstat$/)
		{
			$res{used32}++;
		}
		elsif (m/^\s+U __(|l|f)xstat64$/)
		{
			$res{used64}++;
		}
		elsif (m/^\s+U readdir$/)
		{
			$res{used32}++;
		}
		elsif (m/^\s+U readdir64$/)
		{
			$res{used64}++;
		}
	}
	close $fh;
	push(@results, \%res);
}

# Function to scan a directory
sub scan_directory
{
	my ($path) = @_;
	my $dh;
	return unless opendir($dh,$path);
	while (my $d = readdir $dh)
	{
		next if ($d =~ m/^\./);
		print "$path/$d\n" if $verbose > 2;
		scan_path("$path/$d");
	}
	closedir $dh;
}

# Function to scan something that might be a file or a directory
sub scan_path
{
	my ($path) = @_;
	print "scan_path($path)\n" if $verbose > 2;
	if ( -d $path )
	{
		scan_directory($path);
	}
	elsif ( -e $path )
	{
		scan_file($path);
	}
}

# Scan files and directories specified in the commandline
foreach my $path (@pathnames)
{
	scan_path($path);
}

my @status_strings =
(
	"cannot be read (permission denied)",
	"are scripts (shell, perl, whatever)",
	"don't use any stat() or readdir() family calls at all",
	"use 32-bit stat() or readdir() family interfaces only",
	"use 64-bit stat64() or readdir() family interfaces only",
	"use both 32-bit and 64-bit stat() or readdir() family interfaces",
);

sub STATUS_UNCLEAN { return 3 };
sub STATUS_MIXED { return 5 };
sub STATUS_MAX { return 5 };
sub status
{
	my ($r) = @_;
	return 0 if ($r->{no_perm});
	return 1 if ($r->{not_exe});
	return 2 + ($r->{used64} ? 2 : 0) + ($r->{used32} ? 1 : 0);
}

# Function to generate a summary
sub emit_summary
{
	my @summ;
	my $total = 0;

	foreach my $r (@results)
	{
		my $s = status($r);
		$summ[$s] = 0 unless defined $summ[$s];
		$summ[$s]++;
		$total++;
		printf "%s %s\n", $r->{path}, $status_strings[$s]
		    if ($verbose && ($s == STATUS_UNCLEAN || $s == STATUS_MIXED));
	}

	foreach my $s (0..STATUS_MAX)
	{
		next unless defined $summ[$s];
		printf "%7d %4.1f%% %s\n",
			$summ[$s], (100.0 * $summ[$s] / $total), $status_strings[$s];
	}
}

# Function to dump raw data
sub emit_raw
{
	foreach my $r (@results)
	{
		print "$r->{used32} $r->{used64} $r->{not_exe} $r->{no_perm} $r->{path}\n";
	}
}

emit_raw if $verbose > 1;
emit_summary;

--------------020704050307000508040701--
